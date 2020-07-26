#
# This is our scheduler
# Source: https://github.com/jmettraux/rufus-scheduler
#

require 'rufus-scheduler'
require 'utils'

expired_jobs_scheduler = Rufus::Scheduler.new
pending_payments_scheduler = Rufus::Scheduler.new
expired_password_request_scheduler = Rufus::Scheduler.new
expired_unactivated_accounts_scheduler = Rufus::Scheduler.new
sync_log_scheduler = Rufus::Scheduler.new
calculate_popularity = Rufus::Scheduler.new

calculate_popularity.every '2h',:allow_overlapping => false do
  JobStat.popular_since_yesterday
  Utils.log_info('Calculated popularity')
  log = SchedulerLog.new
  log.scheduler= 'calculate_popularity'
  log.save
end

expired_jobs_scheduler.every '1h',:allow_overlapping => false do
  count = Job.mark_expired_jobs
  Utils.log_info("Expired #{count} jobs")
  log = SchedulerLog.new
  log.scheduler= 'expired_jobs_scheduler'
  log.save
end

pending_payments_scheduler.every '20m',:allow_overlapping => false do
  count = Payment.check_pending_payments
  Utils.log_info("Pending payments = #{count}")
end

expired_password_request_scheduler.every '12h',:allow_overlapping => false do
  count = PasswordRequest.delete_expired_requests
  Utils.log_info("Deleted #{count} password requests")
  SchedulerLog.log 'expired_password_request_scheduler'
end

expired_unactivated_accounts_scheduler.every '6h',:allow_overlapping => false do
  count = User.delete_expired_unactivated_accounts
  Utils.log_info("Deleted #{count} expired accounts.")
  SchedulerLog.log 'expired_unactivated_accounts_scheduler'
end

sync_log_scheduler.every '6h', :allow_overlapping => false do
  last_sync_log_reset = Setting.get_last_sync_log_reset
  sync_log_version = Setting.get_sync_log_version
  if !sync_log_version
    Setting.set_sync_log_version(1)
    sync_log_version = Setting.get_sync_log_version
  end

  version = sync_log_version.value.to_i
  datetime = DateTime.strptime(last_sync_log_reset.value, Setting::DATETIME_FORMAT)
  days_past = (Date.today - datetime.to_date).to_i

  if days_past > 7
    #reset sync log and increment sync log version
    SyncLog.destroy_all
    ActiveRecord::Base.connection.reset_pk_sequence!('sync_logs')
    Setting.set_sync_log_version(version+1)
	Setting.set_last_sync_log_reset(Date.today.to_datetime)
  else
    #do nothing
  end

  SchedulerLog.log 'sync_log_scheduler'
end