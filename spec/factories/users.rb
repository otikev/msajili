# == Schema Information
#
# Table name: users
#
#  id               :integer          not null, primary key
#  first_name       :string(255)
#  last_name        :string(255)
#  email            :string(255)
#  country          :string(255)
#  city             :string(255)
#  password_hash    :string(255)
#  password_salt    :string(255)
#  auth_token       :string(255)
#  company_id       :integer
#  role             :integer
#  created_at       :datetime
#  updated_at       :datetime
#  activated        :boolean          default(FALSE)
#  activation_token :string(255)
#  expiry           :date
#  enabled          :boolean          default(FALSE)
#


require 'faker'
FactoryGirl.define do
  factory :role do
    name 'random'
  end
  factory :user do 
    first_name {Faker::Name.first_name}
    last_name {Faker::Name.last_name}
    email {Faker::Internet.email}
    country 'KE'
    city {Faker::Address.city}
    password '12345'
    password_confirmation '12345'
    
    factory :recruiter do
      role {Role.recruiter}
      company
      activated
    end
    
    factory :admin do
      role {Role.admin}
      company
      activated

      transient do
        job_count 5
      end
      
      after(:create) do |user, evaluator|
        create_list(:job, evaluator.job_count, company: user.company,user: user)
      end
    end
    
    factory :applicant do
      role {Role.applicant}
      company_id nil
      activated
    end

    trait :activated do
      activated true
    end

    trait :not_activated do
      activated false
    end

    trait :expired_not_activated do
      activated false
      expiry (Date.today - 1.days).to_date
    end

    trait :expired_activated do
      activated true
      expiry (Date.today - 1.days).to_date
    end
  end
end
