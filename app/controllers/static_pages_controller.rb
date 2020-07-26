class StaticPagesController < ApplicationController
  layout :resolve_layout

  def pricing
  end

  def help
  end

  def contact
    @contact = Contact.new
  end

  def mobile

  end

  def features
  end

  def feedback
    @contact = Contact.new(params[:contact])
    if @contact.valid?
      Notifications.delay.feedback(@contact)
      flash[:info] = 'Message sent! Thank you for contacting us.'
      redirect_to root_url
    else
      render :action => 'contact'
    end
  end

  def terms_n_conditions

  end

  def privacy_policy

  end

  def test

  end

  private

  def resolve_layout
    if logged_in?
      return 'application'
    else
      return 'home'
    end
  end
end
