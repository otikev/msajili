# == Schema Information
#
# Table name: sync_logs
#
#  id          :integer          not null, primary key
#  record_type :integer
#  record_id   :integer
#  log_type    :integer
#  created_at  :datetime
#  updated_at  :datetime
#

require 'rails_helper'

RSpec.describe SyncLog, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
