class AdminController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :fetch_user, :except => [:signin]

  def index
    if !@staff
      redirect_to adminsignin_path and return false
    end

    if @staff.role == Administrator::ROLE_ADMIN
      # Don't redirect
    elsif @staff.role == Administrator::ROLE_EDITOR
      redirect_to editor_path and return false
    else
      redirect_to logout_path and return false
    end

    @popularity_calculated_at = ''
    setting = Setting.get_popularity_calculated_at
    if setting
      @popularity_calculated_at = setting.value
      @popular_jobs = Job.top_ten_popular
    end

    setting_log_v = Setting.get_sync_log_version
    if setting_log_v
      @sync_log_version = setting_log_v.value
    end

    setting_last_log_reset = Setting.get_last_sync_log_reset

    if !setting_last_log_reset
      date = Date.today - 10
      Setting.set_last_sync_log_reset(date.to_datetime)
      setting_last_log_reset = Setting.get_last_sync_log_reset
    end

    if setting_last_log_reset
      @last_sync_log_reset = setting_last_log_reset.value
    end

  end

  def staff
    if @staff.role != Administrator::ROLE_ADMIN
      redirect_to admin_path and return false
    end

    if request.post?
      if params[:administrator][:id]
        if @staff.id == params[:administrator][:id].to_i
          flash[:danger] = 'Cannot edit yourself, use a different administrator account.'
          redirect_to admin_path and return false
        end
        @user = Administrator.where(:id => params[:administrator][:id].to_i).first
        if @user
          @user.email = params[:administrator][:email]
          @user.first_name = params[:administrator][:first_name]
          @user.last_name = params[:administrator][:last_name]
          @user.role = params[:administrator][:role]
          @user.enabled = params[:administrator][:enabled]
          if params[:administrator][:password].length > 0
            @user.password = params[:administrator][:password]
          end
          if @user.valid?
            @user.save!
            flash[:success] = 'Staff saved successfully'
          else
            flash[:danger] = Utils.get_error_string(@user, 'Staff')
          end
        else
          flash[:danger] = 'No such staff exists!'
        end
      else
        @user = Administrator.new
        @user.email = params[:administrator][:email]
        @user.first_name = params[:administrator][:first_name]
        @user.last_name = params[:administrator][:last_name]
        @user.role = params[:administrator][:role]
        @user.enabled = params[:administrator][:enabled]
        @user.password = params[:administrator][:password]
        if @user.valid?
          @user.save!
          flash[:success] = 'Staff saved successfully'
        else
          flash[:danger] = Utils.get_error_string(@user, 'Staff')
        end
      end
    else
      if params[:id]
        if @staff.id == params[:id].to_i
          flash[:danger] = 'Cannot edit yourself, use a different administrator account.'
          redirect_to admin_path and return false
        end
        @user = Administrator.where(:id => params[:id].to_i).first
        if !@user
          flash[:danger] = 'No such user exists!'
          redirect_to admin_url and return false
        end
      else
        @user = Administrator.new
      end
    end
    @roles = Hash.new
    @roles['Admin'] = Administrator::ROLE_ADMIN
    @roles['Editor'] = Administrator::ROLE_EDITOR

    @statuses = Hash.new
    @statuses['Enabled'] = true
    @statuses['Disabled'] = false
  end

  def new_agent
    if @staff.role != Administrator::ROLE_ADMIN
      redirect_to admin_path and return false
    end
    params[:id]
    agent_request = AgentRequest.where(:id => params[:id].to_i).first
    if agent_request && SalesAgent.where(:email => agent_request.email).first == nil
      @agent = SalesAgent.new_agent(agent_request)
      if @agent.save
        Notifications.delay.sales_agent(@agent)
        flash[:success] = 'Agent accepted!'
      else
        flash[:danger] = 'Something went wrong!'
      end
    end
    redirect_to adminagents_path and return false
  end

  def editor

  end

  def payments
    if @staff.role != Administrator::ROLE_ADMIN
      redirect_to admin_path and return false
    end

  end

  def users
    if @staff.role != Administrator::ROLE_ADMIN
      redirect_to admin_path and return false
    end

  end

  def company
    if @staff.role != Administrator::ROLE_ADMIN
      redirect_to admin_path and return false
    end

    @company = Company.where(:id => params[:id]).first;
    if !@company
      raise ActionController::RoutingError.new('Not Found')
    end
  end

  def modify_token
    if @staff.role != Administrator::ROLE_ADMIN
      redirect_to admin_path and return false
    end
    company = Company.where(:id => params[:token][:company_id]).first;
    token = company.get_token
    if company.package == Package::ON_DEMAND
      token.jobs = params[:token][:jobs].to_i
    elsif company.package == Package::PREMIUM
      token.expiry = params[:token][:expiry].to_date
    end
    token.save!
    redirect_to admincompany_path(id: company.id)
  end

  def change_subscription
    if @staff.role != Administrator::ROLE_ADMIN
      redirect_to admin_path and return false
    end
    company = Company.where(:id => params[:subscribe][:id]).first;
    company.package = params[:subscribe][:package].to_i
    company.save!
    if company.package == Package::FREE || company.package == Package::ON_DEMAND
      company.unpublish_all_open_jobs
      company.disable_all_recruiters
    end
    redirect_to admincompany_path(id: params[:subscribe][:id])
  end

  def companies
    if @staff.role != Administrator::ROLE_ADMIN
      redirect_to admin_path and return false
    end

  end

  def jobs
    if @staff.role != Administrator::ROLE_ADMIN
      redirect_to admin_path and return false
    end

  end

  def agents
    if @staff.role != Administrator::ROLE_ADMIN
      redirect_to admin_path and return false
    end

  end

  def signin
    if request.post?
      email = params[:administrator][:email]
      password = params[:administrator][:password]
      if !email || email == '' || !password || password == ''
        flash.now[:warning]='You must provide an email and password'
        @admin = Administrator.new
      else
        user = Administrator.where(email: email).first

        if user
          @staff = user.authenticate(password, true)
          if @staff
            if !@staff.enabled
              cookies.delete(:staff_auth_token)
              @staff = nil
              flash.now[:danger] = 'Your account has been disabled'
              @admin = Administrator.new
            else
              cookies[:staff_auth_token] = @staff.auth_token
              redirect_to admin_path and return true
            end
          else
            #user found but password is incorrect
            flash.now[:danger]='Invalid username or password'
            @admin = Administrator.new
          end
        else
          #user with email and role not found in db
          flash.now[:danger]='Invalid username or password'
          @admin = Administrator.new
        end
      end
    else
      @admin = Administrator.new
    end
  end

  def change_password
    current_password = params[:administrator][:current_password]
    new_password = params[:administrator][:password]
    new_password_confirmation = params[:administrator][:password_confirmation]

    if @staff.authenticate(current_password, false)
      if new_password == new_password_confirmation
        @staff.change_password(new_password, new_password_confirmation)
        if @staff.errors.any?
          flash[:danger] = Utils.get_error_string(@staff, 'Password NOT changed!')
        else
          flash[:success] = 'Password changed.'
        end
      else
        flash[:danger] = 'The password and password confirmation do not match!'
      end
    else
      flash[:danger] = 'The current password is wrong!'
    end
    redirect_to admin_path
  end

  def logout
    @staff = nil
    cookies.delete(:staff_auth_token)
    redirect_to root_path
  end

  def change_job_status
    @job = Job.where(id: params[:id]).first
    @job.status = params[:status].to_i
    @job.save!
    redirect_to admin_path and return
  end

  def update_job
    @job = Job.where(id: params[:job][:id]).first
    if @job.update(job_params)
      flash[:success] = 'Job successfully updated.'
    else
      flash[:danger] = Utils.get_error_string(@job, 'Job could not be updated.')
    end
    redirect_to admincustomfields_path(id: @job.id, edit: true) and return
  end

  def edit_fields
    @edit = params[:edit] ? params[:edit].to_bool : false
    @job = Job.where(id: params[:id]).first
  end

  def create_job
    @job = Job.new(job_params)
    if @job.save
      flash[:success] = 'Job successfully created.'
      redirect_to admincustomfields_path(id: @job.id)
    else
      flash[:danger] = Utils.get_error_string(@job, 'Job could not be created.')
      @categories = Category.order(:name => :asc).load
      render 'new_job'
    end
  end

  def new_job
    @job = Job.new
    @job.job_type = 1
    @categories = Category.order(:name => :asc).load
  end

  def paymentlist
    if @staff.role != Administrator::ROLE_ADMIN
      redirect_to admin_path and return false
    end
    render :json => ActiveSupport::JSON.encode(Payment.datatable_all(params, view_context))
  end

  def joblist
    render :json => ActiveSupport::JSON.encode(Job.datatable_all(params, view_context))
  end

  def companylist
    if @staff.role != Administrator::ROLE_ADMIN
      redirect_to admin_path and return false
    end
    render :json => ActiveSupport::JSON.encode(Company.datatable(params, view_context))
  end

  def stafflist
    if @staff.role != Administrator::ROLE_ADMIN
      redirect_to admin_path and return false
    end
    render :json => ActiveSupport::JSON.encode(Administrator.staff_datatable(params, view_context))
  end

  def userlist
    if @staff.role != Administrator::ROLE_ADMIN
      redirect_to admin_path and return false
    end
    render :json => ActiveSupport::JSON.encode(Administrator.datatable(params, view_context))
  end

  def agent_request_list
    if @staff.role != Administrator::ROLE_ADMIN
      redirect_to admin_path and return false
    end
    render :json => ActiveSupport::JSON.encode(AgentRequest.datatable(params, view_context))
  end

  def calculate_popularity
    JobStat.popular_since_yesterday
    redirect_to admin_path
  end

  private

  def job_params
    params.require(:job).permit(:company_id, :company_name, :job_type, :category_id, :user_id, :source, :title, :deadline, :country, :city, :id, questions_attributes: [:_destroy, :id, :content, choices_attributes: [:_destroy, :id, :content]], job_fields_attributes: [:_destroy, :id, :title, :content])
  end

  def fetch_user
    begin
      puts '########## fetch admin'
      if !cookies[:staff_auth_token]
        flash[:danger] = 'You have to sign in'
        redirect_to adminsignin_path and return false
      end

      @staff ||= Administrator.find_by_auth_token!(cookies[:staff_auth_token]) if cookies[:staff_auth_token] && cookies[:staff_auth_token].length > 0
      if @staff
        if !@staff.enabled
          cookies.delete(:staff_auth_token)
          flash[:danger] = 'Your account has been disabled'
          redirect_to adminsignin_path and return false
        end
      else
        cookies.delete(:staff_auth_token)
        redirect_to adminsignin_path and return false
      end
    rescue Exception => e
      puts 'Msajili Exception'
      logger.error e.message
      logger.error e.backtrace.join("\n")

      @staff = nil
      cookies.delete(:staff_auth_token)
      redirect_to adminsignin_path and return false
    end
  end
end
