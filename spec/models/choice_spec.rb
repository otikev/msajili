# == Schema Information
#
# Table name: choices
#
#  id          :integer          not null, primary key
#  content     :text
#  question_id :integer
#  created_at  :datetime
#  updated_at  :datetime
#




require 'rails_helper'
require 'faker'

describe Choice do
  it 'has a valid factory' do
    expect(build(:choice)).to be_valid
  end
  
  it 'must have content' do
    expect(build(:choice,content: nil)).not_to be_valid
  end

  it 'must belong to a question' do
    expect(build(:choice, question_id: nil)).not_to be_valid
  end
end
