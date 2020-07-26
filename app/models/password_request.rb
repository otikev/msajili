# == Schema Information
#
# Table name: password_requests
#
#  id         :integer          not null, primary key
#  token      :string(255)
#  expiry     :datetime
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#



class PasswordRequest < ActiveRecord::Base
  require 'utils'
  belongs_to :user

  validates :user, :presence => true
  validates :expiry, :presence => true
  validates :token, :presence => true

  attr_accessor :password, :password_confirmation

  def change_password(password,password_confirmation)
    if password ==password_confirmation
      user.change_password(password,password_confirmation)
      if user.errors.any?
        user.errors.each do |k,v|
          errors.add(k,v)
        end
      end
    else
      errors.add(:base, 'The password and password confirmation do not match!')
    end
  end

  def self.delete_expired_requests
    now = DateTime.current
    requests = PasswordRequest.where('expiry < ?',now)
    count = requests.count
    requests.delete_all
    count
  end

  def self.send_password_reset(email)
    success = false
    user = User.where(:email => email).first
    if user
      begin
      request_pwd = PasswordRequest.new
      request_pwd.user = user
      #generate_token
      request_pwd.token = Digest::SHA1.hexdigest(Utils.random_upcase_string(10))

      #set expiry
      request_pwd.expiry = (DateTime.current + 24.hours).to_datetime

      request_pwd.save!
      Notifications.delay.forgot_password(request_pwd)
      success = true
      rescue
        success = false
      end
    else
      success = false
    end
    success
  end

end
