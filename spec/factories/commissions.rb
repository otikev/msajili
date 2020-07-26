# == Schema Information
#
# Table name: commissions
#
#  id             :integer          not null, primary key
#  amount         :float
#  sales_agent_id :integer
#  payment_id     :integer
#  company_id     :integer
#  created_at     :datetime
#  updated_at     :datetime
#


FactoryGirl.define do
  factory :commission do
    amount 1.5
  end

end
