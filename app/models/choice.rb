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



class Choice < ApplicationRecord
  require 'utils'
  belongs_to :question, inverse_of: :choices #see http://homeonrails.com/2012/10/validating-nested-associations-in-rails/

  validates :question, :presence => true
  validates :content, :presence => true

  def self.create_choice_for(question,content)
    choice = Choice.new
    choice.question = question
    choice.content = content
    choice.save
  end
end
