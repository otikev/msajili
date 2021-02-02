# == Schema Information
#
# Table name: filters
#
#  id         :integer          not null, primary key
#  title      :string(255)
#  job_id     :integer
#  created_at :datetime
#  updated_at :datetime
#


class Filter < ApplicationRecord
  require 'utils'
  belongs_to :job
  has_many :answers

  validates :title, :presence => true
  validates :job, :presence => true

  def set_values(job_id,title)
    self[:job_id]= if job_id != nil then job_id end
    self[:title]= if title != nil then title end
  end

  def self.save_filter(params,job_id)
    if params[:answers] == nil
      return nil
    end

    filter = Filter.where(:job_id => job_id).first
    if !filter
      filter = Filter.new
    end
    filter.set_values(job_id,params[:filter][:title])

    if filter.save
      params[:answers].each do |key, value|
        question = Question.find(key.to_i)
        answer = question.answers.where(:filter_id => filter.id).first
        if !answer
          answer = Answer.new
        end

        if question.has_choices
          answer.set_values(key.to_i,nil,value.to_i,nil,filter.id)
          answer.save
        end
      end
      return filter
    end
    return nil
  end

  def calculate_rating(application)
    total = self.answers.count
    value = 0
    self.answers.each do |a|
      ans = application.answers.where(:question_id => a.question.id).first
      if ans
        if ans.choice_id == a.choice_id
          value += 1
        end
      end
    end

    if total>0
      (value.to_f/total.to_f)*5
    else
      0
    end
  end
end
