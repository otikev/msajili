# == Schema Information
#
# Table name: job_fields
#
#  id         :integer          not null, primary key
#  title      :string(255)
#  content    :text
#  job_id     :integer
#  created_at :datetime
#  updated_at :datetime
#  position   :integer
#

class JobField < SyncBase
  self.table_name = 'job_fields'
  RECORD_TYPE = Msajili::Constants::RECORD_JOB_FIELD

  include ActionView::Helpers::TextHelper
  include ActionView::Helpers::UrlHelper

  belongs_to :job, inverse_of: :job_fields

  validates :title, :presence => true
  validates :content, :presence => true
  validates :job, :presence => true

  DIRECTION_UP = 1
  DIRECTION_DOWN = 2

  before_create {
    set_position
  }

  def self.get_json(job_field_id)
    job_field = JobField.where(:id => job_field_id).first
    if job_field
      return job_field.as_json(except: [:created_at, :updated_at])
    end
    nil
  end

  def set_position
    if !self.position
      last_job_field = JobField.where(:job_id => self.job_id).order(:position => :desc).first
      if last_job_field
        self.position = last_job_field.position + 1
      else
        #This is the first Job Field
        self.position = 1
      end
    end
  end

  def self.create_defaults(job)
    job_field = JobField.new
    job_field.title = 'About'
    job_field.content = 'XXXXXXXXX'
    job_field.job = job
    job_field.save
    job_field = JobField.new
    job_field.title = 'Qualifications'
    job_field.content = 'XXXXXXXXX'
    job_field.job = job
    job_field.save
    job_field = JobField.new
    job_field.title = 'Responsibilities'
    job_field.content = 'XXXXXXXXX'
    job_field.job = job
    job_field.save
  end

  def content_html
    auto_link(self.content)
  end

  def move(direction)
    if direction == DIRECTION_UP
      above = JobField.where(:job_id => self.job_id).where('position < ?', self.position).order(position: :desc).first
      if above
        ActiveRecord::Base.transaction do
          self.position = above.position
          above.position = self.position+1
          above.save!
          self.save!
        end
      end
    elsif direction == DIRECTION_DOWN
      below = JobField.where(:job_id => self.job_id).where('position > ?', self.position).order(position: :asc).first
      if below
        ActiveRecord::Base.transaction do
          self.position = below.position
          below.position = self.position-1
          below.save!
          self.save!
        end
      end
    end
  end
end
