class Report

  attr_accessor :company, :job, :total_jobs, :open_jobs, :closed_jobs, :applications, :procedures_array, :start_date, :end_date

  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end

  def fetch(job)
    if job
      self.job=job
    else
      totaljobs = Job.where('DATE(created_at) >= ? and DATE(created_at) <= ?',start_date,end_date)
      self.total_jobs = totaljobs.count
      openjobs = totaljobs.where(:status => Job.status_open)
      self.open_jobs = openjobs.count
      closedjobs = totaljobs.where(:status => Job.status_closed)
      self.closed_jobs = closedjobs.count
    end

    self.applications = get_applications(job,start_date,end_date)
    self.procedures_array = get_stages(job,start_date,end_date)
  end

  def get_stages(job,start_date,end_date)
    procedures = Procedure.get_procedures(self.company.id)
    procedures_array = []
    procedures.each do |p|
      stages_array = []
      p.stages.each do |s|
        stages_hash = Hash.new
        stages_hash[:procedure] = p.title
        stages_hash[:name] = s.title
        stages_hash[:dropped] = s.get_dropped_applications.count
        stages_array.push(stages_hash)
      end
      procedures_array.push(stages_array)
    end
    procedures_array
  end

  def get_procedure(i)
    json_data = ActiveSupport::JSON.encode(self.procedures_array[i])
    json_data
  end

  def get_applications(job,start_date,end_date)
    if job
      appls = job.get_completed_applications
    else
      appls = Application.joins(:job).where('DATE(applications.created_at) >= ? and DATE(applications.created_at) <= ? and applications.status = ? and jobs.company_id = ?',start_date,end_date,Application.status_complete,self.company.id)
    end

    i=0
    data = []
    start_date.upto(end_date) { |date|
      value = appls.where('DATE(applications.created_at) = ?', date).count

      point = Hash.new
      point[:period] = date
      point[:value] = value
      data.push(point)
      i+=1
    }
    json_data = ActiveSupport::JSON.encode(data)
    json_data
  end

  def persisted?
    false
  end
end