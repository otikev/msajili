# == Schema Information
#
# Table name: stages
#
#  id           :integer          not null, primary key
#  position     :integer
#  title        :string(255)
#  description  :text
#  procedure_id :integer
#  created_at   :datetime
#  updated_at   :datetime
#
# Indexes
#
#  index_stages_on_procedure_id_and_position  (procedure_id,position) UNIQUE
#



require 'rails_helper'

RSpec.describe Stage, :type => :model do
  it 'has a valid factory' do
    expect(build(:stage)).to be_valid
  end

  it 'is invalid without procedure' do
    expect(build(:stage,procedure:nil)).not_to be_valid
  end

  it 'is invalid without title' do
    expect(build(:stage,title:nil)).not_to be_valid
  end
end

describe Stage, '#move(direction)' do
  before do
    @company = create(:company)
    @procedure = @company.procedures.first
  end

  it 'moves stage in right direction' do
    stage = @procedure.get_stage_for_position(1)
    stage.move(Stage::DIRECTION_DOWN)
    expect(stage.position).to eq 2
    stage.move(Stage::DIRECTION_UP)
    expect(stage.position).to eq 1
  end

  context 'when stage is in last position' do
    it 'should not increment position' do
      stage = @procedure.get_stage_for_position(5)
      stage.move(Stage::DIRECTION_DOWN)
      expect(stage.position).to eq 5
    end
  end

  context 'when stage is in first position' do
    it 'should not decrement position' do
      stage = @procedure.get_stage_for_position(1)
      stage.move(Stage::DIRECTION_UP)
      expect(stage.position).to eq 1
    end
  end
end
