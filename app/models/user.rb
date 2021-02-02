# == Schema Information
#
# Table name: users
#
#  id               :bigint           not null, primary key
#  first_name       :string
#  last_name        :string
#  email            :string
#  country          :string
#  city             :string
#  password_hash    :string
#  password_salt    :string
#  auth_token       :string
#  company_id       :bigint
#  role             :bigint
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  activated        :boolean          default(FALSE)
#  activation_token :string
#  expiry           :date
#  enabled          :boolean          default(FALSE)
#
# Indexes
#
#  index_users_on_company_id  (company_id)
#  index_users_on_role        (role)
#

class User < ApplicationRecord
  require 'utils'
  belongs_to :company,inverse_of: :users
  has_many :employers,:dependent => :destroy
  has_many :referees,:dependent => :destroy
  has_many :academic_qualifications,:dependent => :destroy
  has_many :applications,:dependent => :destroy
  has_many :jobs, :through => :applications,:dependent => :destroy
  has_many :comments
  has_many :interviews
  has_many :uploads

  accepts_nested_attributes_for :academic_qualifications, :allow_destroy => true
  accepts_nested_attributes_for :referees, :allow_destroy => true
  accepts_nested_attributes_for :employers, :allow_destroy => true

  attr_accessor :password, :remember_me, :as_admin

  validates :first_name, :presence => true
  validates :country, :presence => true
  validates :city, :presence => true
  validates :role, :presence => true
  validates :password, :presence =>true,:length => { :minimum => 5, :maximum => 40 },:confirmation =>true
  validates :company, :presence => true,:if => :is_recruiter
  validates :email, presence: true, format: { with: Utils::VALID_EMAIL_REGEX },uniqueness: { case_sensitive: false }
  validate :applicant_has_no_company
  validate :enabled_status

  before_save {self.email = email.downcase}
  before_create {
    generate_auth_token
    set_password
    generate_activation_token
    set_enabled_status
  }

  def change_password(new_password,new_password_confirmation)
    begin
      self.password = new_password
      self.password_confirmation = new_password_confirmation
      set_password
      self.save!
      return self
    rescue
      return self.reload
    end
  end

  def is_applicant
    role == Role.applicant
  end

  def is_recruiter
    role == Role.admin || role == Role.recruiter
  end

  def country_name
    country = ISO3166::Country[self[:country]]
    country.translations[I18n.locale.to_s] || country.name
  end

  def set_password
    self[:password_salt] = Utils.random_string(10) if !self.password_salt?
    self[:password_hash] = digest_pwd(password, self.password_salt)
  end

  def is_profile_complete
    complete = false
    if self.employers.count > 0 && self.referees.count > 0 && self.academic_qualifications.count > 0
      complete = true
    end
    complete
  end

  def authenticate(pass,generate_new_token)
    if digest_pwd(pass, self.password_salt) == self.password_hash
      if generate_new_token
        generate_auth_token
        update_attribute('auth_token', self.auth_token)
      end
      self
    else
      nil
    end
  end

  def self.authenticate_session(request_json)
    user = User.where('email ILIKE ? and auth_token LIKE ?', request_json['email'].downcase, request_json['auth_token']).first
    user
  end

  def self.count_for_recruiters(company)
    return User.where(:role => Role.recruiter,:company_id => company.id).count
  end

  def self.count_for_all(company)
    return User.where(:company_id => company.id).count
  end

  def applications_datatable(params,view_context)
    if params[:sSearch]
      phrase = "%#{params[:sSearch]}%".downcase
      applics = self.applications.joins(job: [:company]).where('(jobs.title ILIKE ? or companies.name ILIKE ?)',phrase,phrase).order(:id => :desc).limit(params[:iDisplayLength]).offset(params[:iDisplayStart])
      count = self.applications.joins(job: [:company]).where('(jobs.title ILIKE ? or companies.name ILIKE ?)',phrase,phrase).count
    else
      applics = self.applications.includes(:job).order(:id => :desc).limit(params[:iDisplayLength]).offset(params[:iDisplayStart])
      count = self.applications.count
    end

    application_list = []
    applics.each do |a|
      obj = Hash.new
      obj['company'] = a.job.company.name
      obj['position'] = a.job.title
      obj['deadline'] = view_context.format_date(a.job.deadline)
      if a.stage == nil
        obj['status'] = 'Draft'
      else
        obj['status'] = if a.dropped then 'Dropped' else 'Under review' end
      end
      obj['options'] = view_context.link_to_progress_application(a.id)
      application_list.push(obj)
    end
    data = Hash.new
    data['sEcho'] = params[:sEcho]
    data['iTotalRecords'] = count
    data['iTotalDisplayRecords'] = count
    data['aaData'] = application_list
    data
  end

  def self.datatable(company_id,params,view_context)
    if params[:sSearch]
      phrase = "%#{params[:sSearch]}%".downcase
      users = User.where('(first_name ILIKE ? or last_name ILIKE ?) and company_id = ?',phrase,phrase,company_id).order(:id => :desc).limit(params[:iDisplayLength]).offset(params[:iDisplayStart])
      count = User.where('(first_name ILIKE ? or last_name ILIKE ?) and company_id = ?',phrase,phrase,company_id).count
    else
      users = User.where(:company_id => company_id).order(:id => :desc).limit(params[:iDisplayLength]).offset(params[:iDisplayStart])
      count = User.where(:company_id => company_id).count
    end

    user_list = []
    users.each do |j|
      obj = j.as_json(only:[:first_name,:last_name,:email])
      obj['status'] = j.activated ? "<p class='label label-success'>Activated</p>" : "<p class='label label-danger'>Not activated</p>"
      enabled_status = j.enabled ? "<p class='label label-success'>Enabled</p>" : "<p class='label label-danger'>Disabled</p>"
      obj['status'] = "#{obj['status']} #{enabled_status}"
      if j.role == Role.admin
        obj['action'] = ''
      else
        obj['action'] = j.enabled ? view_context.form_to_disable_user(j.id) : view_context.form_to_enable_user(j.id)
      end

      user_list.push(obj)
    end

    data = Hash.new
    data['sEcho'] = params[:sEcho]
    data['iTotalRecords'] = count
    data['iTotalDisplayRecords'] = count
    data['aaData'] = user_list
    return data
  end

  def send_activate
    #Don't send activation emails if user already activated
    if !activated
      update_attribute('expiry', (Date.today + 7.days))
      Notifications.delay.activate(self)
    end
  end

  def send_recruiter_activate
    #Don't send activation emails if user already activated
    if !activated
      update_attribute('expiry', (Date.today + 7.days))
      Notifications.delay.recruiter_activate(self)
    end
  end

  def self.delete_expired_unactivated_accounts
    #These are accounts that were never activated through the email link and the period expired(7 days)
    today = Date.today
    users = User.where('expiry < ? and activated = false',today)
    count = users.count
    users.delete_all
    count
  end

  def activate?
    update_attribute('activated', true)
    if self.activated
      return true
    else
      return false
    end
  end

  def set_enabled(value)
    #prevent password and password_confirmation validation errors. Don't worry, password wont be affected
    #unless a call is made to set_password
    self.password = '12345'
    self.password_confirmation = '12345'
    self.enabled = value
    self.save
  end

  private
  def digest_pwd(pass, salt)
    Digest::SHA1.hexdigest(pass+salt)
  end

  def applicant_has_no_company
    errors.add(:base, 'Applicant cannot belong to a company') if self.role == Role.applicant && company_id != nil
  end

  def enabled_status
    if role == Role.recruiter && self.id
      existing_user = User.find(self.id)
      #check if the user's enabled status changed from false to true
      if existing_user && existing_user.enabled == false && self.enabled == true
        if company.package == Package::FREE
          errors.add(:base, 'Free package: Only 1 user should be enabled.') #admin is already enabled and counts as 1 user
        elsif company.package == Package::ON_DEMAND
          enabled_users = User.where(:company_id => self.company_id, :enabled => true).count
          if enabled_users >= Package::ON_DEMAND_USER_COUNT
            errors.add(:base, "On-Demand package: Only #{Package::ON_DEMAND_USER_COUNT} users should be enabled.")
          end
        end
      end
    end
  end

  def generate_auth_token
    begin
      self[:auth_token] = Digest::SHA1.hexdigest(Utils.random_string(10))
    end while User.exists?(:auth_token => self[:auth_token])
  end

  def generate_activation_token
    begin
      self[:activation_token] = Utils.random_upcase_string(20)
    end while User.exists?(:activation_token => self[:activation_token])
  end

  def set_enabled_status
    if role == Role.applicant || role == Role.admin
      self.enabled = true
    end
  end
end
