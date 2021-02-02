class AgentsController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :agent_required,:except => [:signin,:index,:agent_request]

  def index
    @agent = SalesAgent.new
    @agent_request = AgentRequest.new
  end

  def home

  end

  def agent_request
    agent_request = AgentRequest.new(agent_request_params)
    if agent_request.save
      flash[:success] = 'Thank you for your interest in becoming a sales agent with Msajili.We will let you know via email.'
    else
      flash[:danger] = Utils.get_error_string(agent_request,'Request could not be saved!')
    end
    redirect_to :action => 'index'
  end

  def contact_list
    render :json=> ActiveSupport::JSON.encode(SalesAgent.companies(@agent_user,params,view_context))
  end


  def signin
      email = params[:sales_agent][:email]
      password = params[:sales_agent][:password]
      if !email || email == '' || !password || password == ''
        flash[:warning]='You must provide an email and password'
        redirect_to agent_path and return false
      else
        user = SalesAgent.where(email: email).first

        if user
          @agent_user = user.authenticate(password)
          if @agent_user
            cookies[:auth_token] = @agent_user.auth_token
            redirect_to agenthome_path and return true
          else
            #user found but password is incorrect
            flash[:danger]='Invalid username or password'
            redirect_to agent_path and return false
          end
        else
          #user with email and role not found in db
          flash[:danger]='Invalid username or password'
          redirect_to agent_path and return false
        end
      end
  end

  def logout
    @agent_user = nil
    cookies.delete(:auth_token)
    cookies.delete(:as_admin)
    redirect_to root_path
  end

  private
  def agent_required
    fetch_agent
    return true if agent_logged_in?
    session[:return_to] = request.url
    flash[:warning]='You have to log in!'
    redirect_to :action => 'index'
  end

  def agent_logged_in?
    !@agent_user.nil?
  end
  helper_method :agent_logged_in?

  def fetch_agent
    begin
      return unless cookies[:auth_token]
      @agent_user ||= SalesAgent.find_by_auth_token!(cookies[:auth_token]) if cookies[:auth_token] && cookies[:auth_token].length > 0
      if !@agent_user
        cookies.delete(:auth_token)
        cookies.delete(:as_admin)
        redirect_to :action => 'signin' and return false
      end
    rescue Exception => e
      @agent_user = nil
      cookies.delete(:auth_token)
      cookies.delete(:as_admin)
      redirect_to :action => 'signin' and return false
    end
  end

  def agent_request_params
    params.require(:agent_request).permit(:first_name,:last_name,:email,:phone)
  end
end
