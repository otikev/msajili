# == Schema Information
#
# Table name: administrators
#
#  id            :integer          not null, primary key
#  email         :string(255)
#  first_name    :string(255)
#  last_name     :string(255)
#  password_hash :string(255)
#  password_salt :string(255)
#  auth_token    :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#  role          :integer          default(1)
#  enabled       :boolean          default(TRUE)
#

class Administrator < ApplicationRecord
  require 'utils'

  attr_accessor :password

  validates :first_name, :presence => true
  validates :last_name, :presence => true
  validates :email, presence: true, format: { with: Utils::VALID_EMAIL_REGEX },uniqueness: { case_sensitive: false }
  validate :validate_password

  ROLE_ADMIN = 1
  ROLE_EDITOR = 2

  before_save{
    self.email = email.downcase
    set_password
  }

  before_create{
    generate_auth_token
  }

  def self.role_name(role)
    name = ''
    if role == ROLE_ADMIN
      name = 'Admin'
    elsif role == ROLE_EDITOR
      name = 'Editor'
    end
    name
  end

  def self.staff_datatable(params,view_context)
    if params[:sSearch]
      phrase = "%#{params[:sSearch]}%".downcase
      users = Administrator.where('(first_name ILIKE ? or last_name ILIKE ? or email ILIKE ?)',phrase,phrase,phrase).order(:role => :asc).limit(params[:iDisplayLength]).offset(params[:iDisplayStart])
      count = Administrator.where('(first_name ILIKE ? or last_name ILIKE ? or email ILIKE ?)',phrase,phrase,phrase).count
    else
      users = Administrator.order(:role => :asc).load.limit(params[:iDisplayLength]).offset(params[:iDisplayStart])
      count = Administrator.all.count
    end

    user_list = []
    users.each do |j|
      obj = j.as_json(only:[:email])
      obj['name'] = j.first_name+' '+j.last_name
      obj['status'] = j.enabled ? "<p class='label label-success'>Enabled</p>" : "<p class='label label-danger'>Disabled</p>"
      obj['role'] = Administrator.role_name(j.role)
      obj['options'] = view_context.link_to_edit_staff(j.id)

      user_list.push(obj)
    end

    data = Hash.new
    data['sEcho'] = params[:sEcho]
    data['iTotalRecords'] = count
    data['iTotalDisplayRecords'] = count
    data['aaData'] = user_list
    return data
  end

  def self.datatable(params,view_context)
    if params[:sSearch]
      phrase = "%#{params[:sSearch]}%".downcase
      users = User.where('(first_name ILIKE ? or last_name ILIKE ? or email ILIKE ?)',phrase,phrase,phrase).order(:id => :desc).limit(params[:iDisplayLength]).offset(params[:iDisplayStart])
      count = User.where('(first_name ILIKE ? or last_name ILIKE ? or email ILIKE ?)',phrase,phrase,phrase).count
    else
      users = User.order(:id => :desc).load.limit(params[:iDisplayLength]).offset(params[:iDisplayStart])
      count = User.all.count
    end

    user_list = []
    users.each do |j|
      obj = j.as_json(only:[:first_name,:last_name,:email])
      obj['status'] = j.activated ? "<p class='label label-success'>Activated</p>" : "<p class='label label-danger'>Not Activated</p>"
      enabled_status = j.enabled ? "<p class='label label-success'>Enabled</p>" : "<p class='label label-danger'>Disabled</p>"
      obj['status'] = "#{obj['status']} #{enabled_status}"
      obj['role'] = Role.role_name(j.role)

      if j.is_applicant
        obj['company'] = '-'
      else
        obj['company'] = j.company.name
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
    if password
      self[:password_salt] = Utils.random_string(10) if !self.password_salt?
      self[:password_hash] = digest_pwd(password, self.password_salt)
    end
  end

  private
  def digest_pwd(pass, salt)
    Digest::SHA1.hexdigest(pass+salt)
  end

  def generate_auth_token
    begin
      self[:auth_token] = Digest::SHA1.hexdigest(Utils.random_string(10))
    end while Administrator.exists?(:auth_token => self[:auth_token])
  end

  def validate_password
    if !id #new record, must provide password
      if !password
        errors.add(:base, 'Password must be provided')
      elsif password.length < 5
        errors.add(:base, 'Password is too short')
      end
    else #Updating record, only validate password if its provided
      if password && password.length < 5
        errors.add(:base, 'Password is too short')
      end
    end
  end
end
