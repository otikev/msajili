# == Schema Information
#
# Table name: sales_agents
#
#  id            :integer          not null, primary key
#  first_name    :string(255)
#  last_name     :string(255)
#  email         :string(255)
#  auth_token    :string(255)
#  password_hash :string(255)
#  password_salt :string(255)
#  referral_id   :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#  phone         :string(255)
#


class SalesAgent < ApplicationRecord
  require 'utils'
  has_many :commissions

  attr_accessor :password

  validates :first_name, :presence => true
  validates :last_name, :presence => true
  validates :phone, :presence => true
  validates :referral_id, :presence => true
  validates :email, presence: true, format: { with: Utils::VALID_EMAIL_REGEX },uniqueness: { case_sensitive: false }
  validates :password, :presence =>true,:length => { :minimum => 5, :maximum => 40 },:confirmation => true

  before_save {self.email = email.downcase}
  before_create {
    generate_auth_token
    set_password
  }

  def self.companies(agent,params,view_context)
    if params[:sSearch]
      phrase = "%#{params[:sSearch]}%".downcase
      companies = Company.where('(name ILIKE ? and referral_id LIKE ?)',phrase,agent.referral_id).order(:id => :desc).limit(params[:iDisplayLength]).offset(params[:iDisplayStart])
      count = Company.where('(name ILIKE ? and referral_id LIKE ?)',phrase,agent.referral_id).count
    else
      companies = Company.where('(referral_id LIKE ?)',agent.referral_id).order(:id => :desc).load.limit(params[:iDisplayLength]).offset(params[:iDisplayStart])
      count = Company.where('(referral_id LIKE ?)',agent.referral_id).count
    end

    company_list = []
    companies.each do |c|
      obj = c.as_json(only:[:name])
      obj[:package] = Package.package_name(c.package)
      obj[:commission] = "Ksh. #{c.calculate_commissions}"
      company_list.push(obj)
    end

    data = Hash.new
    data['sEcho'] = params[:sEcho]
    data['iTotalRecords'] = count
    data['iTotalDisplayRecords'] = count
    data['aaData'] = company_list
    return data
  end

  def self.new_agent(agent_request)
    s_agent = SalesAgent.new
    s_agent.first_name= agent_request.first_name
    s_agent.last_name = agent_request.last_name
    s_agent.email = agent_request.email
    s_agent.phone = agent_request.phone
    s_agent.generated_password
    s_agent.generate_referral_id
    s_agent
  end

  def generated_password
    digested = Digest::SHA1.hexdigest(self.email) #WE strongly encourage agents to change this password once they login
    self.password = digested[0..4]
    self.password
  end

  def generate_referral_id
    begin
      self[:referral_id] = Utils.random_upcase_string(5)
    end while SalesAgent.exists?(:referral_id => self[:referral_id])
  end

  def authenticate(pass)
    if digest_pwd(pass, self.password_salt) == self.password_hash
      #we generate a unique token every time a user logs in.
      generate_auth_token
      update_attribute('auth_token', self.auth_token)
      self
    else
      nil
    end
  end

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

  def set_password
    self[:password_salt] = Utils.random_string(10) if !self.password_salt?
    self[:password_hash] = digest_pwd(password, self.password_salt)
  end

  private
  def digest_pwd(pass, salt)
    Digest::SHA1.hexdigest(pass+salt)
  end

  def generate_auth_token
    begin
      self[:auth_token] = Digest::SHA1.hexdigest(Utils.random_string(10))
    end while User.exists?(:auth_token => self[:auth_token])
  end
end
