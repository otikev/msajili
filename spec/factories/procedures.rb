# == Schema Information
#
# Table name: procedures
#
#  id         :integer          not null, primary key
#  title      :string(255)
#  company_id :integer
#  created_at :datetime
#  updated_at :datetime
#



require 'faker'

FactoryGirl.define do
  factory :procedure do
    title Faker::Lorem.sentence
    company
    after(:create) do |procedure, evaluator|
      create_list(:stage, 4, procedure: procedure)
    end
  end
end
