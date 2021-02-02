class Notifications < ActionMailer::Base

  def feedback(contact)
    @contact = contact
    mail(to: 'contact@msajili.com', subject: @contact.subject)
  end

  def activate(user)
    @user = user
    mail(to: @user.email, subject: 'Account activation at Msajili')
  end

  def recruiter_activate(user)
    @user = user
    mail(to: @user.email, subject: 'Account activation at Msajili')
  end

  def forgot_password(pwd_rqst)
    @password_request = pwd_rqst
    mail(to: @password_request.user.email, subject: 'Password reset instructions')
  end

  def sales_agent(agent)
    @agent = agent
    mail(to: @agent.email, subject: 'Msajili Sales Account')
  end

  def demo(demo)
    @demo = demo
    mail(to: 'contact@msajili.com', subject: 'Demo request')
  end

end