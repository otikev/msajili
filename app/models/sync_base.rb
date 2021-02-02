class SyncBase < ApplicationRecord
  require 'msajili'
  self.abstract_class = true

  # Models extending this one must declare self.table_name = 'the_table_i_really_want'
  #This is to avoid the child classes trying to find a table called sync_bases

  after_create :sync_log_create
  after_save :sync_log_update
  after_destroy :sync_log_destroy

  protected

  def sync_log_create
    if self.class::RECORD_TYPE == Msajili::Constants::RECORD_JOB
      #When a job is created its status is DRAFT so no need to log it for sync
      return
    end

    log = SyncLog.new
    log.log_type = SyncLog::LOG_CREATE
    log.record_id = self.id
    log.record_type = self.class::RECORD_TYPE
    log.save!
  end

  def sync_log_update
    if self.class::RECORD_TYPE == Msajili::Constants::RECORD_JOB
      #When a job is updated and its status is DRAFT there is no need to log it for sync
      job = Job.where(:id => self.id).first
      if job && job.status == Job.status_draft
        return
      end
    end

    #Delete previous update logs, they are redundant
    exists = SyncLog.where(:log_type => SyncLog::LOG_UPDATE, :record_id => self.id,:record_type => self.class::RECORD_TYPE)
    exists.each do |l|
      l.delete
    end

    log = SyncLog.new
    log.log_type = SyncLog::LOG_UPDATE
    log.record_id = self.id
    log.record_type = self.class::RECORD_TYPE
    log.save!
  end

  def sync_log_destroy
    log = SyncLog.new
    log.log_type = SyncLog::LOG_DELETE
    log.record_id = self.id
    log.record_type = self.class::RECORD_TYPE
    log.save!
  end
end
