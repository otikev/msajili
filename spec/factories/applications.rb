# == Schema Information
#
# Table name: applications
#
#  id           :integer          not null, primary key
#  cover_letter :text
#  job_id       :integer
#  user_id      :integer
#  created_at   :datetime
#  updated_at   :datetime
#  status       :integer
#  stage_id     :integer
#  dropped      :boolean          default(FALSE)
#
# Indexes
#
#  index_applications_on_job_id_and_user_id  (job_id,user_id) UNIQUE
#



require 'faker'
FactoryGirl.define do
  factory :application do
    cover_letter 'some random text'
    status Job.status_unpublished
    dropped false
    stage_id 0
    before(:create) do |application,evaluator|
      application.job = create(:company).jobs.first
      application.user = create(:applicant)
    end

    factory :application_no_job do
      after(:create) do |application,evaluator|
        application.job = nil
      end
    end
    factory :application_no_user do
      after(:create) do |application,evaluator|
        application.user = nil
      end
    end
  end

end
