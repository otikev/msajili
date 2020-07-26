# == Schema Information
#
# Table name: job_stats
#
#  id         :integer          not null, primary key
#  views      :integer          default(0)
#  job_id     :integer
#  created_at :datetime
#  updated_at :datetime
#  popularity :integer          default(0)
#

FactoryGirl.define do
  factory :job_stat do
    views 1
  end

end
