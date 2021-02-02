# == Schema Information
#
# Table name: job_stats
#
#  id         :bigint           not null, primary key
#  views      :integer          default(0)
#  job_id     :bigint
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  popularity :integer          default(0)
#
# Indexes
#
#  index_job_stats_on_job_id  (job_id)
#

class JobStat < SyncBase
  self.table_name = 'job_stats'
  RECORD_TYPE = Msajili::Constants::RECORD_JOB_STAT

  belongs_to :job
  has_many :job_stat_logs

  validates :job, :presence => true

  def highest_count
    JobStat.joins('left outer join jobs on job_stats.job_id = jobs.id').where('jobs.status = ?', Job.status_open).maximum('job_stats.popularity')
  end

  def self.get_json(job_stat_id)
    job_stat = JobStat.where(:id => job_stat_id).first
    if job_stat
      return job_stat.as_json(except: [:created_at, :updated_at])
    end
    nil
  end

  def log_view(user, request)
    if user && user.role != Role.applicant
      #There's a user logged in and its either a recruiter or an admin, so don't log this request
      return false
    end

    if self.job.status != Job.status_open
      #Only log/track open jobs
      return false
    end

    if !request.cookie_jar[get_cookie_key]
      request.cookie_jar[get_cookie_key] = generate_cookie_value
    end

    if JobStatLog.exists?(:job_stat_id => self.id, :cookie => request.cookie_jar[get_cookie_key])
      # Ignore, this is a returning user
    else
      # This is a new user
      self.views = self.views + 1
      self.save!
      stat_log = JobStatLog.new
      stat_log.job_stat = self
      stat_log.ip_address = request.remote_ip
      stat_log.cookie = request.cookie_jar[get_cookie_key]
      stat_log.save!
    end
  end

  def self.popular_since_yesterday
    seven_days_ago = Date.today - 1
    today = Date.today+1

    #Reset all popularity values
    open_jobs = Job.where(:status => Job.status_open)
    open_jobs.find_each do |job|
      jobstat = job.get_or_create_job_stat
      jobstat.popularity = 0
      jobstat.save!
    end

    stats = Hash.new
    JobStatLog.where('created_at >= ? and created_at <= ?', seven_days_ago, today).find_each do |log|
      job = log.job_stat.job
      if job
        if job.status == Job.status_open
          jobid = job.id
          if stats["#{jobid}"]
            stats["#{jobid}"] = stats["#{jobid}"] + 1
          else
            stats["#{jobid}"] = 1
          end
        end
      end
    end

    stats.each do |k, v|
      job = Job.where(:id => k.to_i).first
      if job
        jobstat = job.job_stat
        jobstat.popularity = v
        jobstat.save!
      end
    end

    Setting.set_popularity_calculated_at(DateTime.now)
  end

  private

  def generate_cookie_value
    begin
      cookie = Digest::SHA1.hexdigest(Utils.random_string(10))
    end while JobStatLog.exists?(:job_stat_id => self.id, :cookie => cookie)
    cookie
  end

  def get_cookie_key
    "job_#{job.token}"
  end

end
