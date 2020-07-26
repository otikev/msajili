# == Schema Information
#
# Table name: agent_requests
#
#  id         :integer          not null, primary key
#  first_name :string(255)
#  last_name  :string(255)
#  phone      :string(255)
#  email      :string(255)
#  created_at :datetime
#  updated_at :datetime
#


require 'rails_helper'

RSpec.describe AgentRequest, :type => :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
