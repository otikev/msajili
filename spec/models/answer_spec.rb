# == Schema Information
#
# Table name: answers
#
#  id             :integer          not null, primary key
#  content        :text
#  question_id    :integer
#  application_id :integer
#  choice_id      :integer
#  created_at     :datetime
#  updated_at     :datetime
#  filter_id      :integer
#




require 'rails_helper'
require 'faker'

describe Answer do
  it 'has a valid factory' do
    question = create(:question)
    expect(build(:answer,question: question)).to be_valid
  end
  
  it 'must belong to a question' do
    expect(build(:answer, question_id: nil)).not_to be_valid
  end
  
  it 'must have content if question has no choices' do
    question = create(:question)
    expect(build(:answer,content: nil,question: question)).not_to be_valid
    expect(build(:answer,content: Faker::Lorem.sentence,question: question)).to be_valid
  end

  it 'must have choice if question has choices' do
    question = create(:job_question_with_choices)
    choice = question.choices.first
    expect(build(:answer,content: nil,choice_id: choice.id,question_id: question.id)).to be_valid
    expect(build(:answer,choice_id: nil,question_id: question.id)).not_to be_valid
  end
  
end
