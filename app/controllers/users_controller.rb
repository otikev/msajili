class UsersController < ApplicationController
  before_filter :login_required, :except => [:new,:new_admin, :create,:activate,:resend]
  before_filter :recruiter_login_required, :only => :list
  before_filter :admin_login_required, :only => :set_enabled

  def new
    @user = User.new
    respond_to do |format|
      format.html {render :layout => 'home'}
    end
  end
  
  def new_recruiter
    if clearance != Role.admin
      redirect_to root_url and return false
    end
    company = Company.where( id: params[:company_id].to_i).first
    if company && company.package == Package::FREE
      flash[:danger] = 'You cannot add recruiters on the free package.'
      redirect_to dashboard_path and return false
    end

    if !company || company.id != @current_user.company.id
      redirect_to root_url
    else
      @user = User.new
      @user.company = company
    end
  end

  def new_admin
    if request.post?
      admin_params = params[:admin]
      success = false
      company = Company.new
      company.package = admin_params[:package].to_i
      company.name = admin_params[:company_name]
      company.prefix_url
      user = User.new
      user.company=company
      user.first_name = admin_params[:name]
      user.country = '-'
      user.city = '-'
      user.role = Role.admin
      user.email = admin_params[:work_email]
      user.password = admin_params[:password]
      user.password_confirmation = admin_params[:password_confirmation]
      if company.valid? && user.valid?
        ActiveRecord::Base.transaction do
          if company.save
            user.company= company
            user.save!
            success = true
          end
        end
      else
        success = false
        flash[:danger] = Utils.get_error_string(company,'Company') + Utils.get_error_string(user,'User')
      end

      if success
        user.send_activate
        company.set_trial
        flash[:success] = "Sign up successful. An activation email has been sent to #{user.email}. If you don't activate within the next 7 days your account will be deleted."
        redirect_to role_path and return false
      end
    else
      if params[:package]
        @package = params[:package].to_i
      else
        @package = Package::FREE
      end
    end
    respond_to do |format|
      format.html {render :layout => 'home'}
    end
  end

  def activate
    cookies.delete(:auth_token)
    cookies.delete(:as_admin)
    session[:return_to] = nil

    user = User.where(:activation_token => params[:activation_token]).first
    if user
      if user.activated
        #This account had already been activated
        redirect_to root_path and return false
      else
        if user.activate?
          flash[:success]='Your account has been activated.'
          can_admin = (user.role == Role.admin)
          cookies[:auth_token] = user.auth_token
          if can_admin
            cookies[:as_admin] = true
          end
          redirect_to dashboard_path and return false
        else
          flash[:warning]='We could not activate you. Contact us.'
          redirect_to root_path and return false
        end
      end
    else
      flash[:danger] = 'Invalid activation token or the account has been deleted.'
    end
  end

  def set_enabled
    if !@current_user.as_admin
      redirect_to dashboard_path and return false
    end

    user = User.find(params[:user][:id].to_i)
    if user && user.company_id == @current_user.company_id
      enabled = params[:user][:enabled].to_bool
      if user.set_enabled(enabled)
        flash[:success] = 'User successfully updated.'
      else
        flash[:danger] = Utils.get_error_string(user,'User not updated!')
      end
    end

    redirect_to dashboard_path+'#tabs-recruiters'
  end

  def create
    @user = User.new(user_params)
    if @user.role == Role.recruiter
      if @user.save
        @user.send_recruiter_activate
        flash[:success] = "Recruiter created successfully. An activation email has been sent to #{@user.email}"
        redirect_to dashboard_url and return false
      else
        render 'new_recruiter'
      end
    elsif @user.role == Role.applicant
      if @user.save
        @user.send_activate
        flash[:success] = "Sign up successful. An activation email has been sent to #{@user.email}. If you don't activate within the next 7 days your account will be deleted."
        redirect_to role_path and return false
      else
        render 'new', layout: 'home'
      end
    else
      flash[:danger] = 'Could not create user.'
      redirect_to role_path and return false
    end
  end

  def resend
    if request.post?
      user = User.where(:email => params[:activate][:email]).first
      if user
        user.send_activate
      end
      flash[:success] = "An activation email has been sent to #{params[:activate][:email]}."
      redirect_to role_path and return false
    end
  end
  
  def list
    render :json=> ActiveSupport::JSON.encode(User.datatable(@current_user.company.id,params,view_context)) 
  end

  def application_list
    if @current_user && @current_user.is_applicant
      render :json=> ActiveSupport::JSON.encode(@current_user.applications_datatable(params,view_context))
    else
      redirect_to root_url
    end
  end

  def show
    
  end
  
  def index
    
  end
end
