# == Schema Information
#
# Table name: procedures
#
#  id         :integer          not null, primary key
#  title      :string(255)
#  company_id :integer
#  created_at :datetime
#  updated_at :datetime
#



class Procedure < ApplicationRecord
  require 'utils'
  belongs_to :company
  has_many :stages, -> { order 'position ASC' }, inverse_of: :procedure
  has_many :jobs

  validates :company, :presence => true
  validates :title, :presence => true

  accepts_nested_attributes_for :stages, :allow_destroy => true, :update_only => true

  def self.create_default(company)
    procedure = Procedure.new
    procedure.company = company
    procedure.title = 'Default steps'
    if procedure.save
      stage1 = Stage.new
      stage1.title = 'Profile review'
      stage1.description= 'This is where we go through the applicant\'s profile and CV.'
      stage1.procedure = procedure
      stage1.save
      stage2 = Stage.new
      stage2.title = 'Questions review'
      stage2.description= 'This is where we go through the applicant\'s Answers to the screening questions.'
      stage2.procedure = procedure
      stage2.save
      stage3 = Stage.new
      stage3.title = 'Phone interview'
      stage3.description= 'Conduct phone interviews on the applicants.'
      stage3.procedure = procedure
      stage3.save
      stage4 = Stage.new
      stage4.title = 'One on one interview'
      stage4.description= 'Conduct physical interviews.'
      stage4.procedure = procedure
      stage4.save
      stage5 = Stage.new
      stage5.title = 'Shortlist'
      stage5.description= 'Applicants recommended.'
      stage5.procedure = procedure
      stage5.save
    end
  end

  def max_position
    if self.stages.count < 1
      return 0
    end
    self.stages.maximum('position')
  end

  def stages_count
    self.stages.count
  end

  def get_stage_for_position(position)
    self.stages.where(:position => position).first
  end

  def add_to_job(job)
    job.procedure_id = self.id
    job.save
  end

  def self.get_procedures(company_id)
    Procedure.where(:company_id => company_id)
  end

  def self.datatable(company_id,params,view_context)
    if params[:sSearch]
        procedures = Procedure.where('title ILIKE ? and company_id = ?',"%#{params[:sSearch]}%".downcase,company_id).order(:id => :desc).limit(params[:iDisplayLength]).offset(params[:iDisplayStart])
        count = Procedure.where('title ILIKE ? and company_id = ?',"%#{params[:sSearch]}%".downcase,company_id).count
    else
        procedures = Procedure.where(:company_id => company_id).order(:id => :desc).limit(params[:iDisplayLength]).offset(params[:iDisplayStart])
        count = Procedure.where(:company_id => company_id).count
    end

    procedure_list = []
    procedures.each do |p|
      obj = p.as_json(only:[:title])
      obj['stages'] = p.stages_count
      if params[:add_to] == 'true'
        obj['options'] = view_context.link_to_view_procedure(p.id) + view_context.link_to_insert_procedure(p.id,params[:job_token])
      else
        obj['options'] = view_context.link_to_view_procedure(p.id)
      end
      procedure_list.push(obj)
    end

    data = Hash.new
    data['sEcho'] = params[:sEcho]
    data['iTotalRecords'] = count
    data['iTotalDisplayRecords'] = count
    data['aaData'] = procedure_list
    return data
  end

end
