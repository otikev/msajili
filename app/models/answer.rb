# == Schema Information
#
# Table name: answers
#
#  id             :bigint           not null, primary key
#  content        :text
#  question_id    :bigint
#  application_id :bigint
#  choice_id      :bigint
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  filter_id      :integer
#
# Indexes
#
#  index_answers_on_application_id  (application_id)
#  index_answers_on_choice_id       (choice_id)
#  index_answers_on_question_id     (question_id)
#



class Answer < ApplicationRecord
  require 'utils'
  belongs_to :question, inverse_of: :answers
  belongs_to :choice
  belongs_to :application
  belongs_to :filter

  validates :question, :presence => true
  validate :content_and_choice

  def set_values(question_id,application_id,choice_id,content,filter_id)
    self[:question_id]= if question_id != nil then question_id end
    self[:application_id]= if application_id != nil then application_id end
    self[:choice_id]= if choice_id != nil then choice_id end
    self[:content]= if content != nil then content end
    self[:filter_id]= if filter_id != nil then filter_id end
  end

  def self.save_answers(params, user_id)
    job_id = params[:application][:job_id].to_i
    application = Application.where(:job_id => job_id,:user_id => user_id).first

    params[:answers].each do |key, value|
      question = Question.find(key.to_i)
      answer = question.answers.where(:application_id => application.id).first
      if !answer
        answer = Answer.new
      end

      if question.has_choices
        answer.set_values(key.to_i,application.id,value.to_i,nil,nil)
        answer.save
      else
        answer.set_values(key.to_i,application.id,nil,value,nil)
        answer.save
      end
    end
  end

  private
  def content_and_choice
    if question
      if question.has_choices
        if !choice
          errors.add(:base, 'must have a choice')
        end
      else
        if !content
          errors.add(:base, 'must have content')
        end
      end
    end
  end
end
