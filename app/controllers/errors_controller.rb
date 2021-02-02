class ErrorsController < ApplicationController
  def page_not_found
    render :file => 'public/404.html', :status => :not_found, :layout => false
  end
end
