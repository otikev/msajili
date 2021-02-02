# == Schema Information
#
# Table name: scheduler_logs
#
#  id         :bigint           not null, primary key
#  scheduler  :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class SchedulerLog < ApplicationRecord

  def self.log(log_text)
    log = SchedulerLog.new
    log.scheduler= log_text
    log.save
  end
end
