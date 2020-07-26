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




require 'rails_helper'

describe Application do
  it 'has a valid factory' do
    expect(create(:application)).to be_valid
  end
  it 'must have a user' do
    expect(create(:application_no_user)).not_to be_valid
  end
  it 'must have a job' do
    expect(create(:application_no_job)).not_to be_valid
  end
end
