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


FactoryGirl.define do
  factory :sales_agent do
    first_name "MyString"
last_name "MyString"
email "MyString"
auth_token "MyString"
password_hash "MyString"
password_salt "MyString"
referral_id "MyString"
  end

end
