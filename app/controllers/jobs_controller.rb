class JobsController < ApplicationController
  before_filter :login_required, :except => [:display,:browse,:search]

  def new_job
    @uijob = UiJob.new
  end

  def new
    if @current_user.company.package == Package::ON_DEMAND
      if @current_user.company.get_token.jobs < 1
        flash[:danger] = 'You cannot create any jobs until you purchase the tokens on the \'payment\' tab.'
        redirect_to dashboard_path and return false
      end
    elsif @current_user.company.package == Package::PREMIUM
      if @current_user.company.get_token.is_expired
        flash[:danger] = 'You cannot create a job when package is expired. Purchase a period on the \'payments\' tab.'
        redirect_to dashboard_path and return false
      end
    end
    @job = Job.new
    @categories = Category.order(:name => :asc).load
    @procedures = Procedure.where(:company_id => @current_user.company.id).order(:title => :asc)
  end

  def edit_fields
      @edit = params[:edit] ? params[:edit].to_bool : false
      @job = Job.where(id: params[:id]).first

      @breadcrumb = Hash.new
      @breadcrumb['job_status'] = @job.status
      @breadcrumb['job_id'] = @job.id
      @breadcrumb['custom_fields'] = @job.id
  end

  def select_procedure
      @job = Job.where(id: params[:id]).first

      @breadcrumb = Hash.new
      @breadcrumb['job_status'] = @job.status
      @breadcrumb['job_id'] = @job.id
      @breadcrumb['select_procedure'] = @job.id
  end

  def define_questions
    @edit = params[:edit] ? params[:edit].to_bool : false
    @job = Job.where(id: params[:id]).first

    @breadcrumb = Hash.new
    @breadcrumb['job_status'] = @job.status
    @breadcrumb['job_id'] = @job.id
    @breadcrumb['edit_questions'] = @job.id
  end

  def set_filter
    @edit = params[:edit] ? params[:edit].to_bool : false
    @job = Job.where(id: params[:id]).first
    if !@job.has_multiple_choice_questions
      flash[:danger] = 'This job has no screening questions therefore filter cannot be set.'
      redirect_to showjob_path(id: @job.id) and return false
    end

    @breadcrumb = Hash.new
    @breadcrumb['job_status'] = @job.status
    @breadcrumb['job_id'] = @job.id
    @breadcrumb['edit_filters'] = @job.id
  end

  def apply_token
    if @current_user.as_admin
      @job = Job.where(id: params[:id]).first
      #Only admins can apply tokens
      if @job.company.id != @current_user.company.id
        #Job belongs to a different company
        redirect_to dashboard_path and return false
      end

      id = params[:id].to_i
      job_token = params[:token]
      if job_token
        if @job.id == id && @job.token == job_token
          if @current_user.company.get_token.jobs > 0
            @job.spend_token
            flash[:success] = 'Job enabled.'
          else
            flash[:danger] = 'You have 0 tokens!'
          end

          redirect_to dashboard_path and return false
        end
      end
    else
      flash[:danger] = 'Only admins can perform this action.'
      redirect_to dashboard_path and return false
    end
  end

  def create
    @job = Job.new(job_params)
    if @job.save
      flash[:success] = 'Job successfully created.'
      redirect_to customfields_path(id:@job.id)
    else
      flash[:danger] = Utils.get_error_string(@job,'Job could not be created.')
      @categories = Category.order(:name => :asc).load
      @procedures = Procedure.where(:company_id => @current_user.company.id).order(:title => :asc)
      render 'new'
    end
  end

  def update
    if params[:job]
      @job = Job.where(id: params[:job][:id]).first

      if @current_user.company.id != @job.company_id
        #job belongs to a different company
        redirect_to dashboard_path and return false
      end

      if @job.update(job_params)
        flash[:success] = 'Job successfully updated.'
      else
        flash[:danger] = Utils.get_error_string(@job,'Job could not be updated.')
      end
    elsif params[:id]
      @job = Job.where(id: params[:id]).first
      if @current_user.company.id != @job.company_id
        #job belongs to a different company
        redirect_to dashboard_path and return false
      end
    end

    if !@job.has_custom_fields
      redirect_to customfields_path(id: @job.id)
    else
      redirect_to showjob_path(id: @job.id)
    end
  end

  def save
    @job = Job.where(id: params[:job][:id]).first
    if @job.update_attributes(job_params)
      flash[:success] = 'The job has been updated.'
      redirect_to showjob_path(id:@job.id)
    else
      flash[:danger] = 'Job could not be updated'
    end
  end
  
  def show
    @job = Job.includes(:procedure,:filters).where(id: params[:id]).first
    if @current_user.company.package == Package::ON_DEMAND
      if @job.paid_on_demand != 1
        flash[:danger] = 'Job is disabled because you are on the On-Demand package and the job had not been purchased.'
        redirect_to dashboard_path and return false
      end
    elsif @current_user.company.package == Package::PREMIUM
      if @current_user.company.get_token.is_expired
        flash[:danger] = 'Job is disabled because your premium subscription is expired.'
        redirect_to dashboard_path and return false
      end
    end

    @categories = Category.order(:name => :asc).load
    @procedures = Procedure.where(:company_id => @current_user.company.id).order(:title => :asc)

    @filter = @job.filters.first
    @breadcrumb = Hash.new
    @breadcrumb['job_status'] = @job.status
    @breadcrumb['job_id'] = @job.id
  end
  
  def list
    render :json=> ActiveSupport::JSON.encode(Job.datatable(@current_user.company,params,view_context,@current_user))
  end

  
  def set_status
    job = Job.where(token: params[:t]).first
    job.status = params[:status].to_i
    if job.status == Job.status_open && job.procedure == nil && params[:procedure] != nil
      job.procedure_id = params[:procedure].to_i
    end

    if job.save
      flash[:success] = 'The job status has been updated.'
    else
      flash[:danger] = Utils.get_error_string(job,'Could not set job status.')
    end

    redirect_to showjob_path(id:job.id)
  end
  
  def browse
    p = 1
    if params[:page]
      p = params[:page].to_i
    end

    if params[:c]
      @category = Category.where(:id => params[:c].to_i).first
      @jobs = Job.page(p).per(10).where(:category_id => params[:c].to_i,:status => Job.status_open).order(:id => :desc)
    else
      @jobs = Job.page(p).per(10).where(:status => Job.status_open).order(:id => :desc)
    end

    @categories = Category.order(:name => :asc).load

    if logged_in?
      render :layout => 'application'
    else
      render :layout => 'home'
    end
  end

  def jobs

  end
  def search
    p = 1
    if params[:page]
      p = params[:page].to_i
    end

    if params[:search][:q]
      query = "%#{params[:search][:q]}%".downcase
      @jobs = Job.joins('left outer join companies on jobs.company_id = companies.id').page(p).per(10).where('(jobs.title ILIKE ? or jobs.company_name ILIKE ? or companies.name ILIKE ?) and jobs.status = ?',query,query,query,Job.status_open).order(:id => :desc)
    end

    @search_caption = "Search results for : #{params[:search][:q]}"

    @categories = Category.order(:name => :asc).load

    if logged_in?
      render :layout => 'application'
    else
      render :layout => 'home'
    end
  end
  
  def screening
    @job = Job.where(token: params[:t]).first
    if !@job
      redirect_to dashboardrecruiter_path and return false
    end
  end
  
  def save_coverletter
    if @current_user.role != Role.applicant
      flash[:danger] = 'You must be signed in as a Job seeker to apply.'
      redirect_to external_path(t: params[:t]) and return false
    end
    
    job_id = params[:application][:job_id].to_i
    job = Job.where(id: job_id).first
    
    if Application.save_coverletter(params,@current_user.id)
      flash[:success] = 'Cover letter has been saved.'
    else
      flash[:warning] = 'Cover letter could not be saved.'
    end
    redirect_to apply_path(t:job.token)
  end
  
  def save_filter
    job_id = params[:filter][:job_id].to_i
    job = Job.where(id: job_id).first
    
    if !job
      redirect_to dashboard_path and return false
    end
    
    if @current_user.company.id != job.company_id
      #job belongs to a different company
      redirect_to dashboard_path and return false
    end
    
    if Filter.save_filter(params,job_id)
      flash[:success] = 'filter created successfully.'
    else
      flash[:danger] = 'filter could not be created'
    end
    redirect_to  updatejob_path(id: job.id)
  end
  
  def save_answers
    if @current_user.role != Role.applicant
      flash[:danger] = 'You must be signed in as a Job seeker to apply.'
      redirect_to external_path(t: params[:t]) and return false
    end
    
    job_id = params[:application][:job_id].to_i
    job = Job.where(id: job_id).first

    Answer.save_answers(params,@current_user.id)
    flash[:success] = 'Answers submitted successfully.'
    redirect_to apply_path(t:job.token)
  end
  
  def complete
    if @current_user.role != Role.applicant
      flash[:danger] = 'You must be signed in as a Job seeker to apply.'
      redirect_to external_path(t: params[:t]) and return false
    end
    job_id = params[:application][:job_id].to_i
    user_id = @current_user.id
    @application = Application.where(:job_id => job_id,:user_id => user_id).first
    @application.complete
    flash[:success] = 'Application submitted successfully.'
    redirect_to dashboard_path
  end
  
  def apply
    if @current_user.role != Role.applicant
      flash[:danger] = 'You must be signed in as a Job seeker to apply.'
      redirect_to external_path(t: params[:t]) and return false
    end
    
    @job = Job.where(token: params[:t]).first
    if !@job
      flash[:danger] = "Job doesn't exist."
      redirect_to dashboard_path and return false
    end

    if @job.status == Job.status_expired
      flash[:danger] = 'The job has expired.'
      redirect_to external_path(t: params[:t]) and return false
    elsif @job.status == Job.status_closed
      flash[:danger] = 'The job is closed.'
      redirect_to external_path(t: params[:t]) and return false
    elsif @job.status == Job.status_unpublished
      flash[:danger] = 'The job has been unpublished.'
      redirect_to external_path(t: params[:t]) and return false
    end
    
    @application = Application.where(:job_id => @job.id,:user_id => @current_user.id).first
    if !@application
      @application = Application.new
      @application.job_id = @job.id
      @application.user_id = @current_user.id
    elsif @application.get_status == Application.status_complete
      flash[:warning] = 'You already applied for this job.'
      redirect_to dashboard_path
    else
      @application.save #This will help keep application.status value up to date
    end
  end
end
