# == Schema Information
#
# Table name: jobs
#
#  id             :integer          not null, primary key
#  title          :string(255)
#  deadline       :date
#  country        :string(255)
#  city           :string(255)
#  company_id     :integer
#  category_id    :integer
#  created_at     :datetime
#  updated_at     :datetime
#  token          :string(255)
#  status         :integer
#  user_id        :integer
#  procedure_id   :integer
#  paid_on_demand :integer          default(0)
#  job_type       :integer          default(0)
#  company_name   :string(255)
#  source         :text
#
# Indexes
#
#  index_jobs_on_user_id  (user_id)
#

require 'faker'
FactoryGirl.define do
  factory :job do
    title {Faker::Lorem.sentence}
    deadline {Date.new + 1}
    country 'KE'
    city 'Nairobi'
    status 0
    job_type 1
    
    company {create(:company,:premium_package)}
    category_id 1 #TODO
    user {company.get_admins.first}
    procedure_id 1 #TODO
    
    transient do
      choices_question_count 5 #questions with multiple choices
      open_question_count 4#Questions without multiple choices
    end
    
    after(:create) do |job, evaluator|
      create_list(:job_question_with_choices, evaluator.choices_question_count, job: job)
      create_list(:question, evaluator.open_question_count, job: job)
    end
  end
end
