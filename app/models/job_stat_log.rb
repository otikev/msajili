# == Schema Information
#
# Table name: job_stat_logs
#
#  id          :bigint           not null, primary key
#  job_stat_id :bigint
#  ip_address  :string
#  cookie      :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_job_stat_logs_on_job_stat_id  (job_stat_id)
#

class JobStatLog < ApplicationRecord
  belongs_to :job_stat
end
