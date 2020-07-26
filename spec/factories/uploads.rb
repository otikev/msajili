# == Schema Information
#
# Table name: uploads
#
#  id             :integer          not null, primary key
#  upload_type    :integer
#  description    :string(255)
#  url            :string(255)
#  file           :string(255)
#  user_id        :integer
#  created_at     :datetime
#  updated_at     :datetime
#  application_id :integer
#

FactoryGirl.define do
  factory :upload do
    type 1
description "MyString"
url "MyString"
  end

end
