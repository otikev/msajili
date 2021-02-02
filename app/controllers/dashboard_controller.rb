class DashboardController < ApplicationController
  before_filter :login_required
  
  #renders the dashboard for applicants
  def index
    if @current_user.as_admin
      redirect_to dashboardadmin_path and return false
    elsif @current_user.role == Role.admin || @current_user.role == Role.recruiter
      redirect_to dashboardrecruiter_path and return false
    end

    @upload = Upload.new
    @upload.user = @current_user
  end
  
  #renders the dashboard for recruiters
  def recruiter_index
    if @current_user.as_admin
      redirect_to dashboardadmin_path and return false
    elsif @current_user.role == Role.applicant
      redirect_to dashboard_path and return false
    end
  end
  
  #renders the dashboard for admin
  def admin_index
    if !@current_user.as_admin
      if @current_user.role == Role.admin || @current_user.role == Role.recruiter
        redirect_to dashboardrecruiter_path and return false
      else
        redirect_to dashboard_path and return false
      end
    end

    start_date = Date.today - 30
    end_date = Date.today

    @report = Report.new({:start_date => start_date, :end_date => end_date, :company => @current_user.company})
    @report.fetch(nil)
  end

  def recruiters

  end

  def company

  end

  def payments

  end

  def templates

  end

  def procedures
    @breadcrumb = Hash.new
    @breadcrumb['procedures'] = 1
  end

  def jobs
    @status = params[:status].to_i
    @breadcrumb = Hash.new
    @breadcrumb['job_status'] = @status
  end

  def applications

  end

  def job_search
    @categories = Category.order(:name => :asc).all
  end
end
