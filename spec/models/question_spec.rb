# == Schema Information
#
# Table name: questions
#
#  id            :integer          not null, primary key
#  content       :text
#  job_id        :integer
#  created_at    :datetime
#  updated_at    :datetime
#  template_id   :integer
#  position      :integer
#  question_type :integer
#

require 'rails_helper'
require 'faker'

describe Question do
  it 'has a valid factory' do
    expect(build(:question)).to be_valid
  end
  
  it 'must have content' do
    expect(build(:question,content: nil)).not_to be_valid
  end

  it 'cannot belong to both job and template' do
    expect(build(:question, template_id: Faker::Number.number(3))).not_to be_valid
  end
  
  it 'must belong to either a job or template' do
    expect(build(:question, template_id: nil,job_id:nil)).not_to be_valid
  end
end

describe Question, '#has_choices' do
  it 'returns true for valid value' do
   question = create(:job_question_with_choices, choices_count: 3)
   expect(question.has_choices).to eq true
   expect(question.choices.count).to eq 3
  end
  
  it 'returns false for invalid value' do
   question = create(:question)
   expect(question.has_choices).to eq false
  end
end

describe Question, '#get_answer' do
  before do
    user = create(:admin)
    job = create(:job,user: user)
    @application = create(:application, job_id: job.id)
    @question = create(:job_question_with_choices,job_id: @application.job_id)
  end
  
  it 'returns nil if no answer' do
    expect(@question.get_answer(@application)).to eq nil
  end
  
  it 'returns answer if answer exists' do
    params = Hash.new
    params[:application] = Hash.new
    params[:answers] = Hash.new
    
    params[:application][:job_id] = @application.job_id
    if @question.has_choices
      params[:answers][@question.id] = @question.choices.first.id
    end
    
    Answer.save_answers(params,@application.user_id)
    expect(@question.get_answer(@application)).not_to eq nil
  end
end

describe Question, '#is_answered' do
  before do
    user = create(:admin)
    job = create(:job,user: user)
    @application = create(:application, job_id: job.id)
    @question = create(:job_question_with_choices,job_id: @application.job_id)
  end
  
  it 'returns false if unanswered' do
    expect(@question.is_answered(@application)).to eq false
  end
  
  it 'returns true if answered' do
    params = Hash.new
    params[:application] = Hash.new
    params[:answers] = Hash.new
    
    params[:application][:job_id] = @application.job_id
    if @question.has_choices
      params[:answers][@question.id] = @question.choices.first.id
    end
    
    Answer.save_answers(params,@application.user_id)
    
    expect(@question.is_answered(@application)).to eq true
  end
end
