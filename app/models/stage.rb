# == Schema Information
#
# Table name: stages
#
#  id           :integer          not null, primary key
#  position     :integer
#  title        :string(255)
#  description  :text
#  procedure_id :integer
#  created_at   :datetime
#  updated_at   :datetime
#
# Indexes
#
#  index_stages_on_procedure_id_and_position  (procedure_id,position) UNIQUE
#




class Stage < ApplicationRecord
  require 'utils'
  belongs_to :procedure, inverse_of: :stages
  has_many :applications
  has_many :comments

  validates :title, :presence => true
  validates :procedure, :presence => true
  validates :procedure, uniqueness: {scope: :position}, :if => :procedure_exists?

  DIRECTION_UP = 1
  DIRECTION_DOWN = 2

  before_create{assign_position}

  def get_active_applications_for_job(job)
    Application.where(:job_id => job.id, :stage_id => self.id, :dropped => false)
  end

  def get_dropped_applications_for_job(job)
    Application.where(:job_id => job.id, :stage_id => self.id, :dropped => true)
  end

  def get_all_applications_for_job(job)
    Application.where(:job_id => job.id, :stage_id => self.id)
  end

  def get_active_applications
    Application.where(:stage_id => self.id, :dropped => false)
  end

  def get_dropped_applications
    Application.where(:stage_id => self.id, :dropped => true)
  end

  def get_all_applications
    Application.where(:stage_id => self.id)
  end

  def move(direction)
    if direction == DIRECTION_UP
      above = Stage.where(:procedure_id => self.procedure_id,:position => (self.position-1)).first
      if above
        ActiveRecord::Base.transaction do
          above.position = 0
          above.save!
          self.position = self.position-1
          self.save!
          above.position = self.position+1
          above.save!
        end
      end
    elsif direction == DIRECTION_DOWN
      below = Stage.where(:procedure_id => self.procedure_id,:position => (self.position+1)).first
      if below
        ActiveRecord::Base.transaction do
          below.position = 0
          below.save!
          self.position = self.position+1
          self.save!
          below.position = self.position-1
          below.save!
        end
      end
    end
  end

  private
  def assign_position
    max = self.procedure.max_position
    self.position = max+1
  end

  def procedure_exists?
    procedure != nil
  end
end
