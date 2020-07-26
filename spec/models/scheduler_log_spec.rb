# == Schema Information
#
# Table name: scheduler_logs
#
#  id         :integer          not null, primary key
#  scheduler  :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'rails_helper'

RSpec.describe SchedulerLog, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
