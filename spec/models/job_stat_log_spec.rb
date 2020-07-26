# == Schema Information
#
# Table name: job_stat_logs
#
#  id          :integer          not null, primary key
#  job_stat_id :integer
#  ip_address  :string(255)
#  cookie      :text
#  created_at  :datetime
#  updated_at  :datetime
#

require 'rails_helper'

RSpec.describe JobStatLog, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
