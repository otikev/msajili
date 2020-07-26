# == Schema Information
#
# Table name: scheduler_logs
#
#  id         :integer          not null, primary key
#  scheduler  :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class SchedulerLog < ActiveRecord::Base

  def self.log(log_text)
    log = SchedulerLog.new
    log.scheduler= log_text
    log.save
  end
end
