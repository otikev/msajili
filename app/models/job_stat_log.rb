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

class JobStatLog < ActiveRecord::Base
  belongs_to :job_stat
end
