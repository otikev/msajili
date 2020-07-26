# == Schema Information
#
# Table name: job_stats
#
#  id         :integer          not null, primary key
#  views      :integer          default(0)
#  job_id     :integer
#  created_at :datetime
#  updated_at :datetime
#  popularity :integer          default(0)
#

require 'rails_helper'

RSpec.describe JobStat, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
