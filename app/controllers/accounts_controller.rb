class AccountsController < ApplicationController
  layout 'home'
  def signin
    if request.post?
      email = params[:user][:email]
      password = params[:user][:password]
      role = params[:user][:role].to_i
      remember_me = params[:user][:remember_me]
      as_admin = params[:user][:as_admin]
      
      if !email || email == '' || !password || password == ''
        flash.now[:warning]='You must provide an email and password'
        @user = User.new
        @role = role
      else
        can_admin = false
        if role.to_i == Role.recruiter # either admin or recruiter
          user = User.where("email ILIKE ? and (role = #{Role.admin} or role = #{Role.recruiter})",email.downcase).first
          if user
            can_admin = (user.role == Role.admin)
          end
        else
          user = User.where(email: email,role:role.to_i).first
        end
        
        if user
          @current_user = user.authenticate(password,true)
          if @current_user

            if !@current_user.activated
              redirect_to role_path(activated: false, email: @current_user.email) and return false
            end

            if @current_user.enabled || @current_user.role == Role.applicant
              if remember_me == '1'
                puts '######### please remember me!'
                cookies.permanent[:auth_token] = @current_user.auth_token
              else
                puts '######### Do NOT remember me!'
                cookies[:auth_token] = @current_user.auth_token
              end
              if can_admin
                cookies[:as_admin] = true
              end
              if session[:return_to]
                uri = session[:return_to]
                session[:return_to] = nil
                redirect_to uri
              else
                redirect_to dashboard_path
              end
            else
              #user found but account is disabled
              flash.now[:danger]="User #{@current_user.email} is disabled."
              @user = User.new
              @role = role
            end
          else
            #user found but password is incorrect
            flash.now[:danger]='Invalid username or password'
            @user = User.new
            @role = role
          end
        else
          #user with email and role not found in db
          flash.now[:danger]='Invalid username or password'
          @user = User.new
          @role = role
        end
      end
    else
      @role = nil
      puts "role = #{params[:role]}"
      if params[:role]
        @role = params[:role].to_i
        @user = User.new
      end
      if !@role #no role specified
        redirect_to root_url
      end
    end
  end

  def logout
    @current_user = nil
    cookies.delete(:auth_token)
    cookies.delete(:as_admin)
    redirect_to :controller => 'accounts', :action => 'role'
  end
  
  def role
    if logged_in? #there is a user logged in, cant view this page
      puts "user logged in #{@current_user.email}"
      redirect_to dashboard_path and return false
    end
    if params[:activated]
      @show_activation_view = true
      @email = params[:email]
    end
  end

  def password_reset
    if request.post?
        @password_request = PasswordRequest.where(:token => params[:password_request][:token]).first
        if @password_request
          @password_request.change_password( params[:password_request][:password],params[:password_request][:password_confirmation])
          if !@password_request.errors.any?
            flash[:success]='your new password has been saved, you can now login'
            @password_request.delete
            redirect_to role_path
          end
        else
          flash[:danger] = 'Something went wrong!'
        end
    else
      token = params[:token]
      @password_request = PasswordRequest.where(:token => token).first
      if @password_request
      else
        flash[:danger] = 'Invalid password reset link.'
        redirect_to role_path
      end
    end
  end

  def forgot_password
    if @current_user
      redirect_to dashboard_path and return false
    end

    if request.post?
      email = params[:email]
      if email && email.length > 0
        u= User.find_by_email(email)
        if u
          exists = PasswordRequest.where(:user_id => u.id).first
          if exists
            flash[:warning] = "There is a pending password request for this email: #{email}"
          else
            PasswordRequest.send_password_reset(email)
            flash[:info]  = 'Check your email for a password reset link.'
            redirect_to role_path
          end
        else
          #email doesn't exist
          #to prevent bad guys using the password reset tool to know if an email exists we'll just say an email has been sent
          flash[:info]  = 'Check your email for a password reset link.'
          redirect_to  role_path
        end
      else
        flash[:warning] = 'The email cannot be blank'
      end
    end
  end
end
