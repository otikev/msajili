class TemplatesController < ApplicationController
  before_action :recruiter_login_required
  
  def questions
    @template = Template.new
    @template.company_id = @current_user.company_id
    
    @breadcrumb = Hash.new
    @breadcrumb['newtemplate'] = 1
  end
  
  def create
    @template = Template.new(template_params)
    if @template.save
      flash[:success] = 'Template created succesfully.'
      redirect_to showtemplate_path(id: @template.id)
    else
      flash[:danger] = Utils.get_error_string(@template,'Template creation failed.')
      render 'questions'
    end
  end
  
  def list
    company_id = @current_user.company.id
    render :json=> ActiveSupport::JSON.encode(Template.datatable(company_id,params,view_context)) 
  end
  
  def show
    @template = Template.where(id: params[:id]).first
    if @template.company.id != @current_user.company.id
      redirect_to dashboard_path and return false
    end
    @breadcrumb = Hash.new
    @breadcrumb['template_id'] = params[:id]
  end
  
  def edit
    @template = Template.where(id: params[:id]).first
    if @template.company.id != @current_user.company.id
      flash[:danger] = 'You cannot edit this template.'
      redirect_to dashboard_path and return false
    end
    @breadcrumb = Hash.new
    @breadcrumb['edittemplate_id'] = params[:id]
  end
  
  def save
    @template = Template.where(id: params[:template][:id]).first
    if @template.company.id != @current_user.company.id
      flash[:danger] = 'You cannot edit this template.'
      redirect_to dashboard_path and return false
    end
    
    if @template.update_attributes(template_params)
      flash[:success] = 'The template has been updated.'
      redirect_to edittemplate_path(id: @template.id)
    else
      flash[:danger] = 'Template could not be updated.'
      render 'edit'
    end
  end
  
  def insert
    job = Job.where(token:params[:t]).first
    template = Template.where(id:params[:template_id].to_i).first
    template.add_to_job(job)
    flash[:success] = 'Template added successfully.'
    redirect_to showjob_path(id:job.id)
  end
end
