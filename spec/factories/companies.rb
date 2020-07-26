# == Schema Information
#
# Table name: companies
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  about       :text
#  phone       :string(255)
#  country     :string(255)
#  city        :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#  website     :string(255)
#  package     :integer
#  trial_used  :integer          default(0)
#  referral_id :string(255)
#  identifier  :string(255)
#


require 'faker'
FactoryGirl.define do
  factory :company do
    name {Faker::Company.name}
    website 'http://www.test.com'
    about 'some random text'
    phone {Faker::PhoneNumber.phone_number}
    country 'KE'
    city {Faker::Address.city}
    package Package::FREE
    
    transient do
      admin_count 1
      recruiter_count 2
      activated false
    end

    after(:create) do |company, evaluator|
      create(:token, company: company)
      create_list(:admin, evaluator.admin_count, company: company,activated: evaluator.activated)
      create_list(:recruiter, evaluator.recruiter_count, company: company,activated: evaluator.activated)
    end
  end

  trait :on_demand_package do
    package Package::ON_DEMAND
  end

  trait :premium_package do
    package Package::PREMIUM
  end

  trait :invalid_package do
    package 99
  end

  trait :no_package do
    package nil
  end
  
  trait :invalid_website do
    website 'wrongformat'
  end
end
