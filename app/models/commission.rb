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


class Commission < ActiveRecord::Base
  belongs_to :sales_agent
  belongs_to :payment
  belongs_to :company

  validates :amount, :presence => true
  validates :sales_agent, :presence => true
  validates :payment, :presence => true
  validates :company, :presence => true
end
