# == Schema Information
#
# Table name: companies
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  about       :text
#  phone       :string(255)
#  country     :string(255)
#  city        :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#  website     :string(255)
#  package     :integer
#  trial_used  :integer          default(0)
#  referral_id :string(255)
#  identifier  :string(255)
#


class Company < SyncBase
  self.table_name = 'companies'
  RECORD_TYPE = Msajili::Constants::RECORD_COMPANY

  require 'utils'
  has_many :users, inverse_of: :company #recruiters or admins
  has_many :jobs
  has_many :procedures
  has_one :token
  has_many :commissions

  validates :name, :presence => true
  validates :package, :presence => true
  validate :valid_web_url
  validate :valid_package
  validate :valid_referral

  before_save :prefix_url
  after_create :create_default_procedure
  accepts_nested_attributes_for :users

  def calculate_commissions
    total = 0
    self.commissions.each do |c|
      total = total +c.amount
    end
    total
  end

  def get_token
    if self.token
      return self.token
    else
      token = Token.new
      token.company_id = self.id
      token.reset
      return token
    end
  end

  def set_trial
    #Don't apply trial stuff to free package
    if package != Package::FREE
      get_token.apply_trial
    end
  end

  def country_name
    name = ''
    c = ISO3166::Country[self[:country]]
    if c
      name = c.translations[I18n.locale.to_s] || c.name
    end
    name
  end

  def get_admins
    users.where(:role => Role.admin)
  end

  def get_recruiters
    users.where(:role => Role.recruiter)
  end

  def unpublish_all_open_jobs
    jobs = Job.where(:status => Job.status_open, :company_id => self.id)
    jobs.update_all(:status => Job.status_unpublished)
  end

  def disable_all_recruiters
    recruiters = User.where(:company_id => self.id, :role => Role.recruiter)
    count = recruiters.count
    recruiters.update_all(:enabled => false)
    count
  end

  def has_website?
    if self.website == nil
      return false
    elsif self.website.starts_with?('http://') || self.website.starts_with?('https://')
      return true
    end
  end

  def prefix_url
    if self.website != nil && self.website.length > 0
      if self.website.starts_with?('http://') || self.website.starts_with?('https://')
        #Nothing to do
      else
        self.website = "http://#{self.website}"
      end
    end
  end

  def self.datatable(params, view_context)
    if params[:sSearch]
      phrase = "%#{params[:sSearch]}%".downcase
      companies = Company.where('(name ILIKE ? or phone ILIKE ?)', phrase, phrase).order(:id => :desc).limit(params[:iDisplayLength]).offset(params[:iDisplayStart])
      count = Company.where('(name ILIKE ? or phone ILIKE ?)', phrase, phrase).count
    else
      companies = Company.order(:id => :desc).load.limit(params[:iDisplayLength]).offset(params[:iDisplayStart])
      count = Company.all.count
    end

    company_list = []
    companies.each do |j|
      obj = j.as_json(only: [:name, :phone, :website])
      obj['package'] = Package.package_name(j.package)
      obj['country'] = j.country_name
      token = j.get_token
      if j.package == Package::ON_DEMAND
        obj['token'] = token.jobs
      elsif j.package == Package::PREMIUM
        obj['token'] = token.expiry
      else
        obj['token'] = 'N/A'
      end
      obj['action'] = view_context.link_to_view_company(j.id)
      company_list.push(obj)
    end

    data = Hash.new
    data['sEcho'] = params[:sEcho]
    data['iTotalRecords'] = count
    data['iTotalDisplayRecords'] = count
    data['aaData'] = company_list
    return data
  end

  def get_identifier
    if !self.identifier
      create_identifier
    end
    self.identifier
  end

  def self.get_json(company_id)
    company = Company.where(:id => company_id).first
    if company
      return company.as_json(except: [:created_at, :updated_at, :trial_used])
    end
    nil
  end

  protected
  def valid_web_url
    if website == nil || website == '' || website == 'http://'
      return
    end
    prefix_url
    errors.add(:base, 'Invalid website url') if website != nil && !Utils.url_valid?(website)
  end

  def valid_referral
    if self.referral_id == '' || self.referral_id == nil
      return
    end

    agent = SalesAgent.where(:referral_id => self.referral_id).first
    if !agent
      errors.add(:base, 'Invalid Referral Id')
    end
  end

  def valid_package
    if package
      errors.add(:base, 'Invalid package') if package < Package::FREE || package > Package::PREMIUM
    else
      errors.add(:base, 'Package can\'t be blank')
    end
  end

  def create_default_procedure
    create_identifier
    Procedure.create_default(self)
  end

  def create_identifier
    i = 0
    url_name = "#{name}"
    url_name.gsub(/[^0-9a-z ]/i, '') #remove all non-alphanumeric characters but keep the spaces
    url_name.gsub! ' ', '-' # replace all spaces with a dash
    begin
      if i == 0
        self.identifier = "#{url_name}"
      else
        self.identifier = "#{i}-#{url_name}"
      end
      i = i + 1
    end while Company.exists?(:identifier => self.identifier)
    self.save!
  end
end
