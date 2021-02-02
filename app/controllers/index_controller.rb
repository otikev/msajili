class IndexController < ApplicationController
  layout 'home'

  def index
    if logged_in?
      redirect_to dashboard_url and return false
    end
  end

  def demo
    @demo = Demo.new(params[:demo])
    if @demo.valid?
      Notifications.delay.demo(@demo)
      flash[:info] = 'Thank you for requesting a demo, we will contact you as soon as possible.'
    else
      flash[:danger] = Utils.get_error_string(@demo,'Demo request not sent.')
    end
    redirect_to root_url
  end
end
