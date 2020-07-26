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

FactoryGirl.define do
  factory :sync_log do
    record_type 1
record_id 1
log_type 1
  end

end
