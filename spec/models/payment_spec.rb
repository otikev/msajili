# == Schema Information
#
# Table name: payments
#
#  id                              :integer          not null, primary key
#  description                     :string(255)
#  quantity                        :integer
#  package                         :integer
#  status                          :integer
#  total                           :integer
#  pesapal_transaction_tracking_id :string(255)
#  pesapal_merchant_reference      :string(255)
#  company_id                      :integer
#  created_at                      :datetime
#  updated_at                      :datetime
#



require 'rails_helper'

RSpec.describe Payment, :type => :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
