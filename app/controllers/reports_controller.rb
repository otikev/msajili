class ReportsController < ApplicationController
  before_filter :recruiter_login_required
  def index
    if params[:report]
      start_date = params[:report][:start_date].to_date
      end_date = params[:report][:end_date].to_date
    else
      start_date = Date.today - 30
      end_date = Date.today
    end

    @report = Report.new({:start_date => start_date, :end_date => end_date, :company => @current_user.company})
    @report.fetch(nil)
  end
end
