# == Schema Information
#
# Table name: sales_agents
#
#  id            :integer          not null, primary key
#  first_name    :string(255)
#  last_name     :string(255)
#  email         :string(255)
#  auth_token    :string(255)
#  password_hash :string(255)
#  password_salt :string(255)
#  referral_id   :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#  phone         :string(255)
#


require 'rails_helper'

RSpec.describe SalesAgent, :type => :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
