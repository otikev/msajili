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



require 'faker'
FactoryGirl.define do
  factory :choice do
    content Faker::Lorem.sentence
    question
  end
end
