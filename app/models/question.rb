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

class Question < ActiveRecord::Base
  require 'utils'
  belongs_to :job
  belongs_to :template, inverse_of: :questions
  has_many :choices, inverse_of: :question
  has_many :answers, inverse_of: :question
  
  accepts_nested_attributes_for :choices, :allow_destroy => true

  TYPE_OPEN_ENDED = 1
  TYPE_SINGLE_OPTION = 2
  TYPE_MULTIPLE_OPTION = 3

  DIRECTION_UP = 1
  DIRECTION_DOWN = 2

  validates :content, :presence => true
  validate :job_and_template

  before_create{
    self.question_type = TYPE_OPEN_ENDED #default
    set_position
  }

  def set_position
    if !self.position
      last_question = Question.where(:job_id => self.job_id,:template_id => self.template_id).order(:position => :desc).first
      if last_question
        self.position = last_question.position + 1
      else
        #This is the first Job Field
        self.position = 1
      end
    end
  end

  def self.create_defaults(job)
    question = Question.new
    question.content = 'What job responsibilities and duties do you excel at?'
    question.job = job
    question.save
    question = Question.new
    question.content = 'What technical skills and knowledge areas are your strongest?'
    question.job = job
    question.save
    question = Question.new
    question.content = 'Do you have any supplemental skills, knowledge areas or experiences that we should know about?'
    question.job = job
    question.save
    question = Question.new
    question.content = 'What is the minimum starting gross monthly salary that you will accept for this position?'
    question.job = job
    question.save
    Choice.create_choice_for(question,'less than Ksh. 10,000')
    Choice.create_choice_for(question,'10,000 - 19,000')
    Choice.create_choice_for(question,'20,000 - 39,000')
    Choice.create_choice_for(question,'40,000 - 79,000')
    Choice.create_choice_for(question,'80,000 - 160,000')
    Choice.create_choice_for(question,'more than Ksh. 160,000')

    question = Question.new
    question.content = 'What is the highest level of education you have achieved?'
    question.job = job
    question.save
    Choice.create_choice_for(question,'High School')
    Choice.create_choice_for(question,'Associates Degree')
    Choice.create_choice_for(question,'Bachelors Degree')
    Choice.create_choice_for(question,'Masters Degree')
    Choice.create_choice_for(question,'Doctorate Degree')

  end

  def is_answered(application)
    get_answer(application) != nil
  end
  
  def has_choices
    if choices_count > 0
      return true
    end
    false
  end
  
  def choices_count
    self.choices.count
  end
  
  def get_answer(application)
    application.answers.where(:question_id => self.id).includes(:choice).first
  end

  def filter_answer
    answer = nil
    filter = Filter.where(:job_id => self.job.id).first
    if filter
      answer = self.answers.where(:filter_id => filter.id).first
    end
    answer
  end

  def move(direction)
    if direction == DIRECTION_UP
      above = Question.where(:job_id => self.job_id,:template_id => self.template_id).where('position < ?',self.position).order(position: :desc).first
      if above
        ActiveRecord::Base.transaction do
          self.position = above.position
          above.position = self.position+1
          above.save!
          self.save!
        end
      end
    elsif direction == DIRECTION_DOWN
      below = Question.where(:job_id => self.job_id,:template_id => self.template_id).where('position > ?',self.position).order(position: :asc).first
      if below
        ActiveRecord::Base.transaction do
          self.position = below.position
          below.position = self.position-1
          below.save!
          self.save!
        end
      end
    end
  end

  protected
  def job_and_template
    if (self.job != nil || self.job_id != nil) && (self.template != nil || self.template_id != nil)
      errors.add(:base, 'cannot belong to both a job and a template')
    elsif self.job == nil && self.template == nil
      errors.add(:base, 'must belong to either a job or a template')
    end
  end
end
