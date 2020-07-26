# == Schema Information
#
# Table name: templates
#
#  id         :integer          not null, primary key
#  title      :string(255)
#  company_id :integer
#  created_at :datetime
#  updated_at :datetime
#



class Template < ActiveRecord::Base
  require 'utils'
  has_many :questions,-> { order 'position ASC' },inverse_of: :template
  belongs_to :company
  
  accepts_nested_attributes_for :questions, :allow_destroy => true, :update_only => true
  
  validates :company, :presence => true
  validates :title, :presence => true
  
  def questions_count
    self.questions.count
  end
  
  def add_to_job(job)
    if job
      self.questions.each do |q|
        new_q = q.dup
        new_q.template_id = nil
        new_q.job_id = job.id
        new_q.save
        q.choices.each do |c|
          new_c = c.dup
          new_c.question_id = new_q.id
          new_c.save
        end
      end
    end
  end
  
  def self.datatable(company_id,params,view_context)
    if params[:sSearch]
      templates = Template.where('title ILIKE ? and company_id = ?',"%#{params[:sSearch]}%".downcase,company_id).order(:id => :desc).limit(params[:iDisplayLength]).offset(params[:iDisplayStart])
      count = Template.where('title ILIKE ? and company_id = ?',"%#{params[:sSearch]}%".downcase,company_id).count
    else
      templates = Template.where(:company_id => company_id).order(:id => :desc).limit(params[:iDisplayLength]).offset(params[:iDisplayStart])
      count = Template.where(:company_id => company_id).count
    end

    
    template_list = []
    templates.each do |t|
      obj = t.as_json(only:[:title])
      obj['questions'] = t.questions_count
      if params[:add_to] == 'true'
        obj['options'] = view_context.link_to_view_template(t.id) + view_context.link_to_insert_template(t.id,params[:job_token])
      else
        obj['options'] = view_context.link_to_view_template(t.id) + view_context.link_to_edit_template(t.id)
      end
      
       
      template_list.push(obj)
    end
    
    data = Hash.new
    data['sEcho'] = params[:sEcho]
    data['iTotalRecords'] = count
    data['iTotalDisplayRecords'] = count
    data['aaData'] = template_list
    return data
  end
  
end
