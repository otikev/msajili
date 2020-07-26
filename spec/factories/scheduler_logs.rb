# == Schema Information
#
# Table name: scheduler_logs
#
#  id         :integer          not null, primary key
#  scheduler  :string(255)
#  created_at :datetime
#  updated_at :datetime
#

FactoryGirl.define do
  factory :scheduler_log do
    scheduler "MyString"
  end

end
