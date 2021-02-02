# == Schema Information
#
# Table name: commissions
#
#  id             :bigint           not null, primary key
#  amount         :float
#  sales_agent_id :bigint
#  payment_id     :bigint
#  company_id     :bigint
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_commissions_on_company_id      (company_id)
#  index_commissions_on_payment_id      (payment_id)
#  index_commissions_on_sales_agent_id  (sales_agent_id)
#


class Commission < ApplicationRecord
  belongs_to :sales_agent
  belongs_to :payment
  belongs_to :company

  validates :amount, :presence => true
  validates :sales_agent, :presence => true
  validates :payment, :presence => true
  validates :company, :presence => true
end
