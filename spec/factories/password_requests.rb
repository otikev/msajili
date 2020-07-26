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



# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :password_request do
    token Digest::SHA1.hexdigest(Utils.random_upcase_string(10))
    expiry (DateTime.current + 24.hours).to_datetime
    user {create(:applicant)}
  end

  trait :expired do
    expiry (DateTime.current - 1.hours).to_datetime
  end
end
