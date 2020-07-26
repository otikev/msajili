class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :fetch_logged_in_user

  require 'utils'
  require 'contact'
  
  def fetch_logged_in_user
    begin
      @current_url = request.url
      return unless cookies[:auth_token]
      @current_user ||= User.includes(:company).find_by_auth_token!(cookies[:auth_token]) if cookies[:auth_token] && cookies[:auth_token].length > 0
      if @current_user
        if cookies[:as_admin] and cookies[:as_admin] == 'true'
          @current_user.as_admin = true
        else
          @current_user.as_admin = false
        end
        if !@current_user.enabled && @current_user.role != Role.applicant
          cookies.delete(:auth_token)
          cookies.delete(:as_admin)
          redirect_to role_path and return false
        end
      else
        if cookies[:auth_token] && cookies[:auth_token].length > 0
          flash[:warning] = 'You were logged out because someone else has logged in with your account.'
        end
        cookies.delete(:auth_token)
        cookies.delete(:as_admin)
        redirect_to role_path and return false
      end
    rescue Exception => e
      @current_user = nil
      cookies.delete(:auth_token)
      cookies.delete(:as_admin)
      redirect_to role_path and return false
    end
  end
  
  def login_required
    return true if logged_in?
    return true if is_staff_user?
    session[:return_to] = request.url
    flash[:warning]='You have to log in!'
    redirect_to :controller => 'accounts', :action => 'role'
  end

  def is_staff_user?
    return false unless cookies[:staff_auth_token]
    @staff ||= Administrator.find_by_auth_token!(cookies[:staff_auth_token]) if cookies[:staff_auth_token] && cookies[:staff_auth_token].length > 0
    if @staff
      if !@staff.enabled
        cookies.delete(:staff_auth_token)
        return false
      else
        return true
      end
    else
      cookies.delete(:staff_auth_token)
      return false
    end
  end
  def recruiter_login_required
    if logged_in?
      if clearance == Role.recruiter || clearance == Role.admin
        value = true
      else
        value = false
      end
    else
      value = false
    end
    
    if value
      return true
    else
      flash[:warning]='You have to log in as a recruiter!'
      redirect_to :controller => 'accounts', :action => 'role' and return false
    end
  end

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end

  def admin_login_required
    value = false
    if logged_in?
      if clearance == Role.admin
        value = true
      else
        value = false
      end
    else
      value = false
    end
    
    if value
      return true
    else
      flash[:warning]='You have to log in as an admin!'
      redirect_to :controller => 'accounts', :action => 'role' and return false
    end
  end
   
  def logged_in?
    !@current_user.nil?
  end
  helper_method :logged_in?

  def clearance
    if logged_in?
      if @current_user.as_admin
        return Role.admin
      elsif @current_user.role == Role.admin || @current_user.role == Role.recruiter
        return Role.recruiter
      else
        return Role.applicant
      end
    else
      return nil
    end
  end
  helper_method :clearance

  private
  def user_params
    params.require(:user).permit(:first_name,:last_name,:email,:country,:city,:password,:password_confirmation,:company_id,:role, academic_qualifications_attributes: [:institution,:award,:academic_level_id,:_destroy,:id, :start_date,:end_date,:ongoing], referees_attributes:[:first_name,:last_name,:phone,:company,:title,:email,:position,:_destroy,:id], employers_attributes:[:_destroy,:id,:name,:from,:to,:position_held, responsibilities_attributes:[:_destroy,:id,:description]])
  end
  
  def update_user_params
    params.require(:user).permit(:first_name,:last_name,:email,:country,:city,:company_id,:role, academic_qualifications_attributes: [:institution,:award,:academic_level_id,:_destroy,:id, :start_date,:end_date,:ongoing], referees_attributes:[:first_name,:last_name,:phone,:company,:title,:email,:position,:_destroy,:id], employers_attributes:[:_destroy,:id,:name,:from,:to,:position_held, responsibilities_attributes:[:_destroy,:id,:description]])
  end
  
  def company_params
    params.require(:company).permit(:referral_id, :package,:name,:about,:phone,:country,:city,:website, users_attributes:[:first_name,:last_name,:email,:password,:password_confirmation,:company_id,:role,:country,:city])
  end
  
  def job_params
    params.require(:job).permit(:company_id,:job_type,:category_id,:procedure_id,:user_id,:title,:deadline,:country,:city,:id,questions_attributes: [:_destroy,:id,:content,choices_attributes:[:_destroy,:id,:content]],job_fields_attributes: [:_destroy,:id,:title,:content])
  end
  
  def template_params
    params.require(:template).permit(:company_id,:title, questions_attributes: [:_destroy,:id,:content,choices_attributes:[:_destroy,:id,:content]])
  end
  
  def procedure_params
    params.require(:procedure).permit(:company_id,:title, stages_attributes: [:_destroy,:id,:order,:title,:description])
  end
  
  def comment_params
    params.require(:comment).permit(:application_id,:user_id,:stage_id,:message)
  end

  def payment_params
    params.require(:payment).permit(:description,:quantity,:status,:package,:pesapal_transaction_tracking_id,:pesapal_merchant_reference,:company_id)
  end

  def interview_params
    params.require(:interview).permit(:event_date,:start_time,:end_time,:location,:additional_info,:comments,:user_id,:application_id)
  end
end
