class ProfileController < ApplicationController
  before_filter :login_required
  
  def index
  end
  
  def edit  
  end
  
  def save
    @current_user.attributes = update_user_params
    if @current_user.save(validate:false)
      flash[:success] = 'Your profile has been updated'
      redirect_to editprofile_path
    else
      flash[:danger] = 'Profile could not be updated'
      render 'edit'
    end
  end
end
