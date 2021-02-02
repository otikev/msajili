# == Schema Information
#
# Table name: sync_logs
#
#  id          :integer          not null, primary key
#  record_type :integer
#  record_id   :integer
#  log_type    :integer
#  created_at  :datetime
#  updated_at  :datetime
#

class SyncLog < ApplicationRecord
  LOG_CREATE = 1
  LOG_UPDATE = 2
  LOG_DELETE = 3

  def self.build_import(record_type,current_id,limit)
    response = Hash.new
    records = []
    new_current_id = 0
    response['finished'] = true #will be updated

    case record_type
      when Msajili::Constants::RECORD_CATEGORY
        categories = Category.where('id > ?',current_id).limit(limit).order(id: :asc)
        categories.each do |c|
          obj = c.as_json(except:[:created_at,:updated_at])
          obj = Hash[*obj.map{|k, v| [k, v || '']}.flatten] #replace null values with empty string
          records.push(obj)
          new_current_id = c.id
        end
        response['finished'] = limit > categories.size
      when Msajili::Constants::RECORD_COMPANY
        companies = Company.where('id > ?',current_id).limit(limit).order(id: :asc)
        companies.each do |c|
          obj = c.as_json(except:[:created_at,:updated_at])
          obj = Hash[*obj.map{|k, v| [k, v || '']}.flatten]
          records.push(obj)
          new_current_id = c.id
        end
        response['finished'] = limit > companies.size
      when Msajili::Constants::RECORD_JOB
        #Import only open jobs.
        jobs = Job.where('id > ? and status = ?',current_id,Job.status_open).limit(limit).order(id: :asc)
        jobs.each do |c|
          obj = c.as_json(except:[:updated_at])
          obj['created_at'] = c.created_at.strftime('%I:%M %p, %b %d,%Y')
          obj = Hash[*obj.map{|k, v| [k, v || '']}.flatten]
          records.push(obj)
          new_current_id = c.id
        end
        response['finished'] = limit > jobs.size
      when Msajili::Constants::RECORD_JOB_FIELD
        job_fields = JobField.joins(:job).where('job_fields.id > ? and jobs.status = ?',current_id,Job.status_open).limit(limit).order(id: :asc)
        job_fields.each do |c|
          obj = c.as_json(except:[:created_at,:updated_at])
          obj = Hash[*obj.map{|k, v| [k, v || '']}.flatten]
          records.push(obj)
          new_current_id = c.id
        end
        response['finished'] = limit > job_fields.size
      when Msajili::Constants::RECORD_JOB_STAT
        job_stats = JobStat.joins(:job).where('job_stats.id > ? and jobs.status = ?',current_id,Job.status_open).limit(limit).order(id: :asc)
        job_stats.each do |c|
          obj = c.as_json(except:[:created_at,:updated_at])
          obj = Hash[*obj.map{|k, v| [k, v || '']}.flatten]
          records.push(obj)
          new_current_id = c.id
        end
        response['finished'] = limit > job_stats.size
    end

    response['sync_pointer'] = SyncLog.maximum('id')
    response['current_id'] = new_current_id
    response['records'] = records
    return response
  end

  def self.build(current_sync_pointer,limit)
    sync_logs = SyncLog.where('id > ?',current_sync_pointer).limit(limit)
    response = Hash.new
    categories = []
    companies = []
    jobs = []
    job_fields = []
    job_stats = []
    deletions = []

    sync_pointer = current_sync_pointer
    sync_logs.each do |s|
      if s.log_type == LOG_CREATE || s.log_type == LOG_UPDATE
        if s.record_type == Msajili::Constants::RECORD_CATEGORY
          category = category_record(s.record_id)
          categories.push(category) if category
        elsif s.record_type == Msajili::Constants::RECORD_COMPANY
          company = company_record(s.record_id)
          companies.push(company) if company
        elsif s.record_type == Msajili::Constants::RECORD_JOB
          job = job_record(s.record_id)
          jobs.push(job) if job
        elsif s.record_type == Msajili::Constants::RECORD_JOB_FIELD
          job_field = job_field_record(s.record_id)
          job_fields.push(job_field) if job_field
        elsif s.record_type == Msajili::Constants::RECORD_JOB_STAT
          job_stat = job_stat_record(s.record_id)
          job_stats.push(job_stat) if job_stat
        end
      elsif s.log_type == LOG_DELETE
        deletion = Hash.new
        deletion['record_type'] = s.record_type
        deletion['record_id'] = s.record_id
        deletions.push(deletion)
      end
      sync_pointer = s.id
    end

    response['deletions'] = deletions
    response['categories'] = categories
    response['companies'] = companies
    response['jobs'] = jobs
    response['job_fields'] = job_fields
    response['job_stats'] = job_stats
    response['sync_pointer'] = sync_pointer
    response['finished'] = limit > sync_logs.size
    return response
  end

  private

  def self.category_record(id)
    category = Category.where(:id => id).first
    if category
      obj = category.as_json(except:[:created_at,:updated_at])
      obj = Hash[*obj.map{|k, v| [k, v || '']}.flatten]
      return obj
    end
    nil
  end

  def self.company_record(id)
    company = Company.where(:id => id).first
    if company
      obj = company.as_json(except:[:created_at,:updated_at])
      obj = Hash[*obj.map{|k, v| [k, v || '']}.flatten]
      return obj
    end
    nil
  end

  def self.job_record(id)
    job = Job.where(:id => id).first
    if job
      obj = job.as_json(except:[:updated_at])
      obj['created_at'] = job.created_at.strftime('%I:%M %p, %b %d,%Y')
      obj = Hash[*obj.map{|k, v| [k, v || '']}.flatten]
      return obj
    end
    nil
  end

  def self.job_field_record(id)
    job_field = JobField.where(:id => id).first
    if job_field
      obj = job_field.as_json(except:[:created_at,:updated_at])
      obj = Hash[*obj.map{|k, v| [k, v || '']}.flatten]
      return obj
    end
    nil
  end

  def self.job_stat_record(id)
    job_stat = JobStat.where(:id => id).first
    if job_stat
      obj = job_stat.as_json(except:[:created_at,:updated_at])
      obj = Hash[*obj.map{|k, v| [k, v || '']}.flatten]
      return obj
    end
    nil
  end
end
