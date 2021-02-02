# == Schema Information
#
# Table name: applications
#
#  id           :integer          not null, primary key
#  cover_letter :text
#  job_id       :integer
#  user_id      :integer
#  created_at   :datetime
#  updated_at   :datetime
#  status       :integer
#  stage_id     :integer
#  dropped      :boolean          default(FALSE)
#
# Indexes
#
#  index_applications_on_job_id_and_user_id  (job_id,user_id) UNIQUE
#

class Application < ApplicationRecord
  require 'utils'

  belongs_to :user
  belongs_to :job
  has_many :answers
  belongs_to :stage
  has_many :comments
  has_many :interviews
  has_many :uploads, :dependent => :destroy

  validates :user,:presence => true
  validates :job,:presence => true
  validate :job_applicants_count

  before_save {set_status}

  def attach(upload)
    if !has_attached?(upload)
      puts 'Not attached'
      attachment = Upload.new(upload.attributes.merge({:application_id => self.id, :id => nil, :created_at => nil,:updated_at => nil}))
      attachment.save!
    else
      puts 'Already attached'
    end
  end

  def has_attached?(upload)
    Upload.where(:file => upload.file,:application_id => self.id).count > 0
  end

  def has_attachments?
    self.uploads.count>0
  end

  def drop
    self.dropped = true
    self.save
  end

  def advance
    current = self.stage.position
    stage = self.job.procedure.get_stage_for_position(current+1)
    if stage
      self.stage_id = stage.id
      self.save!
    end
  end

  def self.save_coverletter(params,user_id)
    job_id = params[:application][:job_id].to_i
    application = Application.where(:job_id => job_id,:user_id => user_id).first
    if !application
      application = Application.new
      application.job_id = job_id
      application.user_id = user_id
      application.save
    end

    application.cover_letter = params[:application][:cover_letter]
    return application.save
  end

  def has_cover_letter
    (self[:cover_letter] && self[:cover_letter].size > 0) ? true : false
  end

  def get_status
    if !self[:status] || self[:status] == 0
      return 1
    end
    self[:status]
  end

  def complete
    stage = self.job.procedure.get_stage_for_position(1)
    if stage
      self[:stage_id] = stage.id
      self[:status] = Application.status_complete
      return self.save
    end
    nil
  end

  def self.status_complete
    return 4
  end

  def get_next_application
    next_application = Application.where('id > ? and job_id = ?',self.id,self.job.id).order(:id => :asc).limit(1).first
    next_application
  end

  def get_previous_application
    previous_application = Application.where('id < ? and job_id = ?',self.id,self.job.id).order(:id => :desc).limit(1).first
    previous_application
  end

  def self.datatable(params,view_context)
    job_id = params[:job_id].to_i
    filter_id = params[:filter_id].to_i
    only_active = params[:only_active].to_bool

    if Utils.is_numeric? params[:stage_id]
      stage_id = params[:stage_id].to_i
      if only_active
        applications = Application.where(:job_id => job_id,:dropped => false,:stage_id => stage_id).order(:id => :asc).limit(params[:iDisplayLength]).offset(params[:iDisplayStart])
        count = Application.where(:job_id => job_id,:dropped => false,:stage_id => stage_id).count
      else
        applications = Application.where(:job_id => job_id,:stage_id => stage_id).order(:id => :asc).limit(params[:iDisplayLength]).offset(params[:iDisplayStart])
        count = Application.where(:job_id => job_id,:stage_id => stage_id).count
      end
    else
      if only_active
        applications = Application.where(:job_id => job_id,:dropped => false).order(:id => :asc).limit(params[:iDisplayLength]).offset(params[:iDisplayStart])
        count = Application.where(:job_id => job_id,:dropped => false).count
      else
        applications = Application.where(:job_id => job_id).order(:id => :asc).limit(params[:iDisplayLength]).offset(params[:iDisplayStart])
        count = Application.where(:job_id => job_id).count
      end
    end



    filter = Filter.where(:id=>filter_id).first

    application_list = []
    applications.each do |a|
      user = a.user

      obj = Hash.new
      obj['id'] = a.id
      obj['name'] = user.first_name + ' ' + user.last_name
      if filter
        obj['rating'] = filter.calculate_rating(a)
      else
        obj['rating'] = 0
      end

      obj['stage'] = a.stage.title
      obj['options1'] = view_context.link_to_view_application(a.id)
      obj['options2'] = a.dropped ? '' : view_context.link_to('Drop', view_context.dropapplicant_path(application_id: a.id), class:'btn btn-danger btn-xs')
      obj['status'] = a.dropped ? "<p class='btn-danger btn-xs'>Dropped</p>" : "<p class='btn-success btn-xs'>Active</p>"
      application_list.push(obj)
    end
    data = Hash.new
    data['sEcho'] = params[:sEcho]
    data['iTotalRecords'] = count
    data['iTotalDisplayRecords'] = count
    data['aaData'] = application_list
    return data
  end

  def all_questions_answered
    self.job.questions.each do |q|
      if !q.is_answered(self)
        return false
      end
    end
    true
  end

  private

  def is_new
    self.id == nil
  end

  def job_applicants_count
    if job
      if is_new && job.limit_reached
        errors.add(:base,'Job has reached the maximum number of applicants.')
      end
    else
      errors.add(:base,'Job can\'t be blank.')
    end
  end

  def set_status
    if self[:status] == Application.status_complete
      #This application was finalized, cannot edit the status
      return true
    end

    if !has_cover_letter
      self[:status] = 1
      self[:stage_id] = 0
    elsif !all_questions_answered
      self[:status] = 2
      self[:stage_id] = 0
    else
      self[:status] = 3
      self[:stage_id] = 0
    end
  end
end
