# == Schema Information
#
# Table name: procedures
#
#  id         :integer          not null, primary key
#  title      :string(255)
#  company_id :integer
#  created_at :datetime
#  updated_at :datetime
#



require 'rails_helper'

RSpec.describe Procedure, :type => :model do
  it 'has a valid factory' do
    expect(build(:procedure)).to be_valid
  end

  it 'is invalid without company' do
    expect(build(:procedure,company:nil)).not_to be_valid
  end

  it 'is invalid without title' do
    expect(build(:procedure,title:nil)).not_to be_valid
  end
end

describe Procedure, '.create_default(company)' do
  before do
    @company = create(:company)
  end

  it 'creates default procedure' do
    expect(@company.procedures.count).to eq 1
    Procedure.create_default(@company)
    expect(@company.procedures.count).to eq 2 #new default procedure created
  end
end

describe Procedure, '#max_position' do
  before do
    @company = create(:company)
    @procedure = @company.procedures.first
  end

  it 'returns the highest position of the stages' do
    expect(@procedure.max_position).to eq 5 #the default created procedure has 5 stages
  end
end

describe Procedure, '#stages_count' do
  before do
    @company = create(:company)
    @procedure = @company.procedures.first
  end

  it 'returns the correct number of stages' do
    expect(@procedure.stages_count).to eq 5 #the default created procedure has 5 stages
  end
end

describe Procedure, '#get_stage_for_position(position)' do
  before do
    @company = create(:company)
    @procedure = @company.procedures.first
  end

  it 'returns the correct stage at the position' do
    stage = @procedure.get_stage_for_position(2)
    expect(stage.position).to eq 2
  end
end

describe Procedure, '#add_to_job(job)' do
  before do
    @company = create(:company)
    @procedure = @company.procedures.first
    @job = @company.jobs.first
  end

  it 'sets the procedure on a job' do
    @procedure.add_to_job(@job)
    expect(@job.procedure.id).to eq @procedure.id
  end
end
