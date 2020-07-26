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

FactoryGirl.define do
  factory :administrator do
    email "MyString"
auth_token "MyString"
first_name "MyString"
last_name "MyString"
  end

end
