class CareerPageController < ApplicationController

  layout 'career_page'

  def jobs
    @company = Company.where(:identifier => params[:identifier]).first
    p = 1
    if params[:page]
      p = params[:page].to_i
    end

    @jobs = Job.page(p).per(10).where(:status => Job.status_open,:company_id => @company.id).order(:id => :desc)
  end

  #external url for showing a job posting
  def display
    #dont show job if it has been unpublished and the current user is not a recruiter from the job's company
    @job = Job.where(token: params[:t]).first
    @error_message = nil

    if !@job || @job.status == Job.status_draft
      flash[:danger] = 'The job you are looking for doesn\'t exist'
      redirect_to root_path and return false
    else
      if @job.status == Job.status_unpublished && (!@current_user || !@current_user.company || @current_user.company.id != @job.company.id)
        @error_message = 'This job has been unpublished.'
      end

      if @job.status == Job.status_closed && (!@current_user || !@current_user.company || @current_user.company.id != @job.company.id)
        @error_message = 'This job has been closed.'
      end

      if @job.limit_reached
        @error_message = 'This job has reached the maximum number of applicants.'
      end
      if !@job.internal_job?
        @categories = Category.order(:name => :asc).load
      end
      @job.get_or_create_job_stat.log_view(@current_user,request)
    end
  end
end
