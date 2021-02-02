class ProcessController < ApplicationController
  before_action :recruiter_login_required, :except => [:application]
  
  def index
    if params[:t]
      @job = Job.where(token: params[:t]).first
    elsif params[:filter][:t]
      @job = Job.where(token: params[:filter][:t]).first
    end

    if @job.company.id != @current_user.company.id
      #This job belongs to a different company
      redirect_to dashboard_path and return false
    end
    if @current_user.company.package == Package::ON_DEMAND
      if @job.paid_on_demand != 1
        flash[:danger] = 'Job is disabled because you are on the On-Demand package and the job had not been purchased.'
        redirect_to dashboard_path and return false
      end
    end

    if params[:stage]
      @stage = params[:stage].to_i
    end

    filter = @job.filters.first
    if filter
      @filter_id = filter.id
    else
      @filter_id = 0
    end
    
    @breadcrumb = Hash.new
    @breadcrumb['job_status'] = @job.status
    @breadcrumb['job_token'] = @job.token

    @only_active = false
    if params[:filter] && params[:filter][:only_active] == 'true'
      @only_active = true
    end
  end
  
  def list
    render :json=> ActiveSupport::JSON.encode(Application.datatable(params,view_context)) 
  end

  def application
    if !@current_user
      #No user logged in
      redirect_to root_path and return false
    end

    @application = Application.includes(:user,:job).where(:id => params[:id].to_i).first
    if @application.user.id != @current_user.id
      #This application belongs to a different user
      redirect_to dashboard_path and return false
    end

    if @application.stage == nil # Application hasn't been submitted
      redirect_to apply_path(t: @application.job.token) and return false
    end

    @is_applicant = true
    @application = Application.includes(:user,:job).where(:id => params[:id].to_i).first
    @wizard = @application.job.get_processing_wizard(@application.stage.position)

    @breadcrumb = Hash.new
    @breadcrumb['job_status'] = @application.job.status
    @breadcrumb['job_token'] = @application.job.token
    @breadcrumb['application_id'] = @application.id
    render 'view'
  end

  def view
    @is_applicant = false
    @application = Application.includes(:user,:job).where(:id => params[:id].to_i).first
    @wizard = @application.job.get_processing_wizard(@application.stage.position)
    @comments = Comment.includes(:stage,:user).where(:application_id => params[:id].to_i).order(:id => :desc)
    @comment = Comment.new
    @comment.application_id = @application.id
    @comment.user_id = @current_user.id
    @comment.stage_id = @application.job.get_active_stage.id
    
    @breadcrumb = Hash.new
    @breadcrumb['job_status'] = @application.job.status
    @breadcrumb['job_token'] = @application.job.token
    @breadcrumb['application_id'] = @application.id

    @next_applicant = @application.get_next_application
    @previous_applicant = @application.get_previous_application
  end
  
  def create_comment
    comment = Comment.new(comment_params)
    if !comment.save
      flash[:danger] = 'Comment creation failed.'
    end
    redirect_to application_path(id: params[:comment][:application_id])
  end
  
  def drop
    id = params[:application_id].to_i
    application = Application.includes(:job).where(:id => id).first
    application.drop
    redirect_to processjob_path(t: application.job.token,stage: application.stage.id)
  end
  
  def advance
    id = params[:application_id].to_i
    application = Application.includes(:job).where(:id => id).first
    application.advance
    redirect_to application_path(id: application.id)
  end
  
  def filter
    filter = Filter.includes(:job).where(:id => params[:id].to_i).first
    if !filter
      redirect_to dashboard_url and return false
    end
    redirect_to processjob_path(t: filter.job.token,filter:filter.id)
  end
end
