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



require 'faker'
FactoryGirl.define do
  factory :answer do 
    content Faker::Lorem.sentence
    choice_id nil
    question_id nil
    filter_id nil
    application_id nil
  end  
end
