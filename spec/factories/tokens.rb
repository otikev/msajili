# == Schema Information
#
# Table name: tokens
#
#  id         :integer          not null, primary key
#  jobs       :integer
#  expiry     :date
#  company_id :integer
#  created_at :datetime
#  updated_at :datetime
#




# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :token do
    jobs 15
    expiry (Date.today + 5.days).to_date
    company
  end
end
