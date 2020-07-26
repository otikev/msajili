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

FactoryGirl.define do
  factory :question do 
    content {Faker::Lorem.sentence}
    job {create(:job)}
    factory :template_question_without_choices do
      template_id {Faker::Number.number(3)}
      job_id nil
    end
    
    factory :job_question_with_choices do
      template_id nil

      transient do
        choices_count 3
      end
      
      after(:create) do |question, evaluator|
        create_list(:choice, evaluator.choices_count, question: question)
      end
    end
    
    factory :template_question_with_choices  do
      template_id {Faker::Number.number(3)}
      job_id nil

      transient do
        choices_count 3
      end
      
      after(:create) do |question, evaluator|
        create_list(:choice, evaluator.choices_count, question: question)
      end
    end
    
  end
end
