# == Schema Information
#
# Table name: job_stat_logs
#
#  id          :integer          not null, primary key
#  job_stat_id :integer
#  ip_address  :string(255)
#  cookie      :text
#  created_at  :datetime
#  updated_at  :datetime
#

FactoryGirl.define do
  factory :job_stat_log do
    ip_address "MyString"
cookie "MyText"
applicant_id 1
  end

end
