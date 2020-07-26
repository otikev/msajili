# == Schema Information
#
# Table name: settings
#
#  id         :integer          not null, primary key
#  key        :string(255)
#  value      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Setting < ActiveRecord::Base
  DATETIME_FORMAT = '%I:%M %p, %b %d,%Y'
  POPULARITY_CALCULATED_AT = 'popularity-calculated-at'
  LAST_SYNC_LOG_RESET = 'last-sync-log-reset'
  SYNC_LOG_VERSION = 'sync-log-version'

  def self.get_popularity_calculated_at
    setting = Setting.where(:key => Setting::POPULARITY_CALCULATED_AT).first
    setting
  end

  def self.set_popularity_calculated_at(datetime)
    setting = Setting.get_popularity_calculated_at
    if !setting
      setting = Setting.new
      setting.key=Setting::POPULARITY_CALCULATED_AT
    end
    setting.value= datetime.strftime(DATETIME_FORMAT)
    setting.save!
  end

  def self.get_last_sync_log_reset
    setting = Setting.where(:key => Setting::LAST_SYNC_LOG_RESET).first
    setting
    #if setting
    #  datetime = DateTime.strptime(setting.value, DATETIME_FORMAT)
    #else
    #  date = Date.today
    #  Setting.set_last_sync_log_reset(date.to_datetime)
    #  datetime = Setting.get_last_sync_log_reset
    #end
    #datetime
  end

  def self.set_last_sync_log_reset(datetime)
    setting = Setting.get_last_sync_log_reset
    if !setting
      setting = Setting.new
      setting.key=Setting::LAST_SYNC_LOG_RESET
    end
    setting.value= datetime.strftime(DATETIME_FORMAT)
    setting.save!
  end

  def self.get_sync_log_version
    setting = Setting.where(:key => Setting::SYNC_LOG_VERSION).first
    setting
    #if setting
    #  puts 'Setting found'
    #  version = setting.value
    #else
    #  puts 'Setting not found!'
    #  Setting.set_sync_log_version(1)
    #  version = Setting.get_sync_log_version
    #end
    #version.to_i
  end

  def self.set_sync_log_version(version)
    setting = Setting.get_sync_log_version
    if !setting
      setting = Setting.new
      setting.key = Setting::SYNC_LOG_VERSION
    end
    setting.value = "#{version}"
    setting.save!
  end
end
