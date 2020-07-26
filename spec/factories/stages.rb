# == Schema Information
#
# Table name: stages
#
#  id           :integer          not null, primary key
#  position     :integer
#  title        :string(255)
#  description  :text
#  procedure_id :integer
#  created_at   :datetime
#  updated_at   :datetime
#
# Indexes
#
#  index_stages_on_procedure_id_and_position  (procedure_id,position) UNIQUE
#



require 'faker'

FactoryGirl.define do
  factory :stage do
    title Faker::Lorem.sentence
    description Faker::Lorem.sentence
    procedure
  end
end
