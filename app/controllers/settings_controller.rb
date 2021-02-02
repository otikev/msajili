class SettingsController < ApplicationController
  before_action :login_required
  def index
  end


  def change_password
    current_password = params[:user][:current_password]
    new_password = params[:user][:password]
    new_password_confirmation = params[:user][:password_confirmation]

    should_redirect = true
    if @current_user.authenticate(current_password,false)
      if new_password == new_password_confirmation
        @current_user.change_password(new_password,new_password_confirmation)
        if @current_user.errors.any?
          should_redirect = false
          flash[:danger] = 'Password NOT changed!'
          render 'index'
        else
          flash[:success] = 'Password changed.'
        end
      else
        flash[:danger] = 'The password and password confirmation do not match!'
      end
    else
      flash[:danger] = 'The current password is wrong!'
    end

    if should_redirect
      redirect_to settings_path
    end
  end

end
