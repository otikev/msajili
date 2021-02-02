# == Schema Information
#
# Table name: jobs
#
#  id             :integer          not null, primary key
#  title          :string(255)
#  deadline       :date
#  country        :string(255)
#  city           :string(255)
#  company_id     :integer
#  category_id    :integer
#  created_at     :datetime
#  updated_at     :datetime
#  token          :string(255)
#  status         :integer
#  user_id        :integer
#  procedure_id   :integer
#  paid_on_demand :integer          default(0)
#  job_type       :integer          default(0)
#  company_name   :string(255)
#  source         :text
#
# Indexes
#
#  index_jobs_on_user_id  (user_id)
#

class Job < SyncBase
  self.table_name = 'jobs'
  RECORD_TYPE = Msajili::Constants::RECORD_JOB

  TYPE_INTERNAL = 0
  TYPE_ANONYMOUS = 1

  require 'utils'
  belongs_to :user
  belongs_to :company
  belongs_to :category, inverse_of: :jobs
  has_many :applications
  has_many :users, :through => :applications #applicants
  has_many :questions, -> { order 'position ASC' }
  has_many :filters
  has_many :job_fields, -> { order 'position ASC' }, inverse_of: :job
  belongs_to :procedure
  has_one :job_stat

  accepts_nested_attributes_for :questions, :allow_destroy => true, :update_only => true
  accepts_nested_attributes_for :job_fields, :allow_destroy => true, :update_only => true

  validates :user, :presence => true, :if => :internal_job?
  validates :company, :presence => true, :if => :internal_job?
  validates :category, :presence => true
  validate :free_package_active_jobs, :if => :internal_job?
  validate :on_demand_package_tokens_available, :if => :internal_job?
  validate :premium_package_not_expired, :if => :internal_job?
  validates :procedure, :presence => true, :if => :internal_job?

  after_create {
    create_defaults
    create_stats_record
  }

  before_create {
    generate_token
    self[:status]=Job.status_draft
    if internal_job?
      spend_token
    end
  }

  before_save {
    if self[:id] && !self[:token] #record exists but has no token
      generate_token
    end

    if self.status == Job.status_expired
      #job was expired
      if self.deadline.to_date >= Time.new.to_date
        self.status = Job.status_unpublished
      end
    end
  }

  def self.get_json(job_id)
    job = Job.where(:id => job_id).first
    if job
      job_json = job.as_json(except: [:created_at, :updated_at])
      job_fields_json = JSON.parse('[]')
      job_fields = JobField.where(:job_id => job_id)
      job_fields.each do |jf|
        job_fields_json.push(JobField.get_json(jf.id))
      end
      job_json['job_fields'] = job_fields_json
      job_json['job_stat'] = JobStat.get_json(job.get_or_create_job_stat.id)
      return job_json
    end
    nil
  end

  def country_name
    country_obj = ISO3166::Country[country]
    country_obj.translations[I18n.locale.to_s] || country_obj.name
  end

  def summary
    summary = job_fields.order(:id => :asc).first
    if summary
      return summary.content
    else
      return "#{title} at #{dynamic_company_name}"
    end
  end

  def dynamic_company_name
    c_name = internal_job? ? company.name : company_name
    return c_name
  end

  def create_defaults
    JobField.create_defaults(self)
    Question.create_defaults(self)
  end

  def get_or_create_job_stat
    create_stats_record
    return self.job_stat
  end

  def create_stats_record
    if !JobStat.exists?(:job_id => self.id)
      stat = JobStat.new
      stat.job = self
      stat.save!
      self.job_stat = stat
    end
  end

  def get_creation_step
    if !self.id
      return 1
    elsif !self.procedure_id
      return 2
    elsif !has_questions
      return 3
    end
    nil #all steps completed
  end

  def get_title_for_step(step)
    if step == 1
      'Job details'
    elsif step == 2
      'Define procedure'
    elsif step == 3
      'Screening questions'
    end
  end

  def get_next_stage
    stage = get_active_stage
    self.procedure.get_stage_for_position(stage.position+1)
  end

  def get_active_stage
    steps = self.procedure.stages_count
    steps.times do |i|
      stage = self.procedure.get_stage_for_position(i+1)
      if stage && stage.get_active_applications_for_job(self).count > 0
        return stage
      end
    end
    nil
  end

  def get_processing_wizard(active_position)
    steps = self.procedure.stages_count

    wizard = Hash.new
    wizard['steps'] = steps
    wizard['active_step'] = active_position
    titles = Array.new(wizard['steps'])

    i=1
    while i<=wizard['steps'] do
      stage = self.procedure.get_stage_for_position(i)
      titles[i] = stage.title
      i+=1
    end
    wizard['titles'] = titles
    wizard
  end

  def get_completed_applications
    self.applications.where(:status => Application.status_complete)
  end

  def get_trend_data
    data = Hash.new

    first_day = self.created_at.to_date
    last_day = self.deadline.to_date
    dayCount = 0
    first_day.upto(last_day) {
      dayCount+=1
    }

    labels = Array.new(dayCount)
    values = Array.new(dayCount)
    appls = get_completed_applications
    i=0
    first_day.upto(last_day) { |date|
      labels[i] = ''
      values[i] = appls.where('DATE(updated_at) = ?', date).count
      i+=1
    }
    data['labels'] = labels
    data['values'] = values
    data
  end

  #Used for admin users
  def self.count_added_today_by_user(user_id)
    today = Time.new.to_date
    jobs = Job.where('DATE(created_at) = ? and user_id = ? and status = ?', today, user_id, Job.status_open)
    count = jobs.count
    count
  end

  def self.count_added_today
    today = Time.new.to_date
    jobs = Job.where('DATE(created_at) = ? and status = ?', today, Job.status_open)
    count = jobs.count
    count
  end

  def self.count_expiring_today
    today = Time.new.to_date
    jobs = Job.where('DATE(deadline) = ?', today)
    count = jobs.count
    count
  end

  def self.mark_expired_jobs
    today = Time.new.to_date
    jobs = Job.where('DATE(deadline) < ? and status = ?', today, Job.status_open)
    count = jobs.count

    jobs.each do |j|
      # use Job.save so that callbacks are executed.
      # Job class needs to be logged for sync if changes occur
      j.status = Job.status_expired
      j.save
    end
    count
  end

  def has_questions
    self.questions.count > 0
  end

  def has_multiple_choice_questions
    value = false
    if has_questions
      self.questions.each do |q|
        if q.has_choices
          value = true
        end
      end
    end
    value
  end

  def has_filters
    self.filters.count > 0
  end

  def self.category_count(category)
    if category == 0
      count = Job.where(:status => status_open).count
    else
      count = Job.where(:category_id => category, :status => status_open).count
    end
    count
  end

  def self.status_unpublished
    return 1
  end

  def self.status_open
    return 2
  end

  def self.status_expired
    return 3
  end

  def self.status_closed
    return 4
  end

  def self.status_draft
    return 5
  end

  def self.status_name_for_code(code)
    if code == 0
      return 'All'
    elsif code == status_open
      return 'Open'
    elsif code == status_expired
      return 'Expired'
    elsif code == status_unpublished
      return 'Unpublished'
    elsif code == status_closed
      return 'Closed'
    elsif code == status_draft
      return 'Draft'
    end
  end

  def self.count_for_status(company_id, status)
    if status == 0
      return Job.where(:company_id => company_id).count
    else
      return Job.where(:status => status, :company_id => company_id).count
    end

  end

  def self.datatable_all(params, view_context)
    job_type = params[:job_type]
    if params[:sSearch]
      phrase = "%#{params[:sSearch]}%".downcase
      jobs = Job.where('(title ILIKE ?) and job_type = ?', phrase, job_type).order(:id => :desc).limit(params[:iDisplayLength]).offset(params[:iDisplayStart])
      count = Job.where('(title ILIKE ?) and job_type = ?', phrase, job_type).count
    else
      jobs = Job.where(:job_type => job_type).order(:id => :desc).limit(params[:iDisplayLength]).offset(params[:iDisplayStart])
      count = Job.where(:job_type => job_type).count
    end

    job_list = []
    jobs.each do |j|
      obj = j.as_json(only: [:title, :deadline])
      if j.status == Job.status_draft
        success_text = "<p class='label label-primary'>#{Job.status_name_for_code(j.status)}</p>"
        option_buttons = view_context.link_to_edit_anonymous_job_custom_fields(j.id)+view_context.nbsp(1)+
            view_context.link_to_edit_anonymous_job(j.id, status_open, 'publish')+view_context.nbsp(1)+
            view_context.link_to_edit_anonymous_job(j.id, status_closed, 'close')
      elsif j.status == Job.status_open
        success_text = "<p class='label label-success'>#{Job.status_name_for_code(j.status)}</p>"
        option_buttons = view_context.link_to_edit_anonymous_job_custom_fields(j.id)+view_context.nbsp(1)+
            view_context.link_to_edit_anonymous_job(j.id, status_unpublished, 'unpublish')
      elsif j.status == Job.status_expired
        success_text = "<p class='label label-warning'>#{Job.status_name_for_code(j.status)}</p>"
        option_buttons = view_context.link_to_edit_anonymous_job_custom_fields(j.id)+view_context.nbsp(1)+
            view_context.link_to_edit_anonymous_job(j.id, status_closed, 'close')
      elsif j.status == Job.status_closed
        success_text = "<p class='label label-info'>#{Job.status_name_for_code(j.status)}</p>"
        option_buttons = view_context.link_to_edit_anonymous_job_custom_fields(j.id)+view_context.nbsp(1)+
            view_context.link_to_edit_anonymous_job(j.id, status_open, 'publish')
      elsif j.status == Job.status_unpublished
        success_text = "<p class='label label-danger'>#{Job.status_name_for_code(j.status)}</p>"
        option_buttons = view_context.link_to_edit_anonymous_job_custom_fields(j.id)+view_context.nbsp(1)+
            view_context.link_to_edit_anonymous_job(j.id, status_open, 'publish')+view_context.nbsp(1)+
            view_context.link_to_edit_anonymous_job(j.id, status_closed, 'close')
      end

      if job_type.to_i == TYPE_ANONYMOUS
        obj['views'] = j.get_or_create_job_stat.views
      else
        obj['applicants'] = j.get_completed_applications.count
      end

      obj['status'] = success_text
      obj['deadline'] = view_context.format_date(obj['deadline'])
      obj['company'] = j.internal_job? ? j.company.name : j.company_name
      obj['options'] = option_buttons
      job_list.push(obj)
    end

    data = Hash.new
    data['sEcho'] = params[:sEcho]
    data['iTotalRecords'] = count
    data['iTotalDisplayRecords'] = count
    data['aaData'] = job_list
    return data
  end

  def self.datatable(company, params, view_context, user)
    if params[:sSearch] && params[:sSearch].length > 0
      if params[:filter].to_i == 0
        jobs = Job.where('title ILIKE ? and company_id = ?', "%#{params[:sSearch]}%".downcase, company.id).order(:id => :desc).limit(params[:iDisplayLength]).offset(params[:iDisplayStart])
        count = Job.where('title ILIKE ? and company_id = ?', "%#{params[:sSearch]}%".downcase, company.id).count
      else
        jobs = Job.where('title ILIKE ? and status = ? and company_id = ?', "%#{params[:sSearch]}%".downcase, params[:filter].to_i, company.id).order(:id => :desc).limit(params[:iDisplayLength]).offset(params[:iDisplayStart])
        count = Job.where('title ILIKE ? and status = ? and company_id = ?', "%#{params[:sSearch]}%".downcase, params[:filter].to_i, company.id).count
      end

    else
      if params[:filter].to_i == 0
        jobs = Job.where(:company_id => company.id).order(:id => :desc).limit(params[:iDisplayLength]).offset(params[:iDisplayStart])
        count = Job.where(:company_id => company.id).count
      else
        jobs = Job.where(:status => params[:filter].to_i, :company_id => company.id).order(:id => :desc).limit(params[:iDisplayLength]).offset(params[:iDisplayStart])
        count = Job.where(:status => params[:filter].to_i, :company_id => company.id).count
      end
    end

    on_demand = false
    premium = false
    expired = false
    if company.package == Package::ON_DEMAND
      on_demand = true
    elsif company.package == Package::PREMIUM
      premium = true
      if company.get_token.is_expired
        expired = true
      end
    end

    job_list = []
    jobs.each do |j|
      obj = j.as_json(only: [:title, :deadline])

      valid_options1 = view_context.link_to_edit_job(j.id)
      valid_options2 = view_context.link_to_process_job(j.token)
      if on_demand
        if j.paid_on_demand != 1
          if user.as_admin
            obj['options1'] = ''
            obj['options2'] = view_context.link_to_apply_token(j.id)
          else
            obj['options1'] = ''
            obj['options2'] = "<p class='btn btn-danger btn-xs'>Disabled</p>"
          end
        else
          obj['options1'] = valid_options1
          obj['options2'] = valid_options2
        end
      elsif premium
        if expired
          obj['options1'] = ''
          obj['options2'] = "<p class='btn btn-danger btn-xs'>Disabled</p>"
        else
          obj['options1'] = valid_options1
          obj['options2'] = valid_options2
        end
      else
        obj['options1'] = valid_options1
        obj['options2'] = valid_options2
      end
      if j.status == Job.status_draft
        success_text = "<p class='label label-primary'>#{Job.status_name_for_code(j.status)}</p>"
      elsif j.status == Job.status_open
        success_text = "<p class='label label-success'>#{Job.status_name_for_code(j.status)}</p>"
      elsif j.status == Job.status_expired
        success_text = "<p class='label label-warning'>#{Job.status_name_for_code(j.status)}</p>"
      elsif j.status == Job.status_closed
        success_text = "<p class='label label-info'>#{Job.status_name_for_code(j.status)}</p>"
      elsif j.status == Job.status_unpublished
        success_text = "<p class='label label-danger'>#{Job.status_name_for_code(j.status)}</p>"
      end

      obj['applicants'] = j.get_completed_applications.count
      obj['status'] = success_text
      obj['deadline'] = view_context.format_date(obj['deadline'])
      job_list.push(obj)
    end

    data = Hash.new
    data['sEcho'] = params[:sEcho]
    data['iTotalRecords'] = count
    data['iTotalDisplayRecords'] = count
    data['aaData'] = job_list
    data
  end

  def negotiable
    self.salary_negotiable.to_bool
  end

  def limit_reached
    if !internal_job?
      return false
    end
    val = false
    if company.package == Package::FREE && applications.count >= Package::FREE_CANDIDATE_COUNT
      val = true
    end
    val
  end

  def spend_token
    if company.package == Package::ON_DEMAND && self.paid_on_demand != 1
      ActiveRecord::Base.transaction do
        token = company.get_token
        token.jobs = token.jobs - 1
        token.save!

        self.paid_on_demand = 1
        if self.id && self.id > 0
          # record already created
          self.save!
        end
      end
    end
  end

  def has_custom_fields
    self.job_fields.count > 0
  end

  def has_procedure
    self.procedure != nil
  end

  def internal_job?
    job_type == TYPE_INTERNAL
  end

  def self.top_ten_popular
    jobs = Job.joins('left outer join job_stats on jobs.id = job_stats.job_id').where('jobs.status = ?', Job.status_open).order('job_stats.popularity DESC').limit(10).offset(0)
    jobs
  end

  private

  def generate_token
    len = 7
    begin
      self[:token] = Utils.random_upcase_string(len)
      len = len+1
    end while Job.exists?(:token => self[:token])
  end

  def premium_package_not_expired
    if company.package == Package::PREMIUM
      if !self.id && company.get_token.is_expired #new record
        errors.add(:base, "Premium package: You cannot create a job when package is expired. Purchase a period on the 'payments' tab.")
      end
    end
  end

  def on_demand_package_tokens_available
    if company.package == Package::ON_DEMAND
      if !self.id && company.get_token.jobs < 1 #new record
        errors.add(:base, "On-Demand package: You don't have tokens to create a job. Purchase the tokens on the 'payments' tab.")
      end
    end
  end

  def free_package_active_jobs
    if company.package == Package::FREE && self.status == Job.status_open
      active_jobs = Job.where(:status => Job.status_open, :company_id => self.company_id)
      if active_jobs.count > 0
        #There's already an open job, check if its this current job or a different one
        errors.add(:base, "Free package: You've reached the limit of open jobs. You can only have 1 open job on the free package. Upgrade your subscription to lift this restriction.") if active_jobs.first.id != self.id
      end
    end
  end
end
