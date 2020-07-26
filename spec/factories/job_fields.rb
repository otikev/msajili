# == Schema Information
#
# Table name: job_fields
#
#  id         :integer          not null, primary key
#  title      :string(255)
#  content    :text
#  job_id     :integer
#  created_at :datetime
#  updated_at :datetime
#  position   :integer
#

FactoryGirl.define do
  factory :job_field do
    title "MyString"
  end

end
