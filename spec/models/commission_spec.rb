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


require 'rails_helper'

RSpec.describe Commission, :type => :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
