# == Schema Information
#
# Table name: tokens
#
#  id         :integer          not null, primary key
#  jobs       :integer
#  expiry     :date
#  company_id :integer
#  created_at :datetime
#  updated_at :datetime
#




class Token < ActiveRecord::Base
  require 'utils'
  belongs_to :company
  validates :company, :presence => true

  def reset
    self.jobs = 0
    self.expiry = Date.today - 1 #yesterday
    self.save
  end

  def add_jobs(n)
    if self.jobs
      self.jobs = self.jobs + n
    else
      self.jobs = n
    end
    self.save
  end

  def extend_expiry(months)
    days = months*31
    if self.expiry
      self.expiry = self.expiry + days
    else
      self.expiry = Date.today + days
    end
    self.save
  end

  def days_to_expiry
    if is_expired
      val = 0
    else
      val = self.expiry - Date.today
    end
    val.to_i
  end

  def is_expired
    val = true
    if self.expiry && self.expiry > Date.today
      val = false
    end
    val
  end

  def apply_trial
    if !company.trial_used.to_bool
      ActiveRecord::Base.transaction do
        reset
        if company.package == Package::ON_DEMAND
          update_attribute('jobs', 1)
          update_attribute('expiry', Date.today - 1)
          company.update_attribute('trial_used', 1)
        elsif company.package == Package::PREMIUM
          update_attribute('jobs', 0)
          update_attribute('expiry', Date.today + Package::PREMIUM_TRIAL_DAYS_COUNT)
          company.update_attribute('trial_used', 1)
        end
      end
    end
  end
end
