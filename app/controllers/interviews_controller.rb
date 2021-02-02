class InterviewsController < ApplicationController
  before_action :recruiter_login_required

  def calendar
    if params[:application_id]
      application = Application.includes(:job).where(id: params[:application_id]).first
      #check if job application exists and that it belongs to the current user's company
      if !application || application.job.company.id != @current_user.company.id
        redirect_to root_url and return false
      end

      @interview = Interview.where(:application_id => params[:application_id].to_i).first
      if !@interview
        @interview = Interview.new
        @interview.application_id = params[:application_id].to_i
        @interview.user_id = @current_user.id
      end
    end
  end

  def list
    render :json=> ActiveSupport::JSON.encode(Interview.events(params,view_context,@current_user))
  end

  def schedule
    if params[:interview][:id] != ''
      @interview = Interview.find(params[:interview][:id].to_i)
      if @interview.update(interview_params)
        redirect_to calendar_path
      else
        render 'calendar'
      end
    else
      @interview = Interview.new(interview_params)
      if @interview.save
        redirect_to calendar_path
      else
        render 'calendar'
      end
    end
  end

  def show

  end
end
