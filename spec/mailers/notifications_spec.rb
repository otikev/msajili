require 'rails_helper'
require 'contact'

RSpec.describe Notifications, :type => :mailer do
  describe 'feedback(contact)' do
    before do
      @contact = Contact.new
      @contact.name = 'kev'
      @contact.email = 'kev@test.com'
      @contact.subject = 'test subject'
      @contact.message = 'sample message body'
      @mail = Notifications.feedback(@contact)
    end

    it 'renders the subject' do
      expect(@mail.subject).to eql(@contact.subject)
    end

    it 'renders the receiver email' do
      expect(@mail.to).to eql(['contact@msajili.com'])
    end

    it 'renders the sender email' do
      expect(@mail.from).to eql(['no-reply@msajili.com'])
    end

    it 'assigns @contact.name' do
      expect(@mail.body.encoded).to match ("Feedback from #{@contact.name}")
    end
  end

  describe 'activate(user)' do
    before do
      @user = create(:applicant)
      @mail = Notifications.activate(@user)
    end

    it 'renders the subject' do
      expect(@mail.subject).to eql('Account activation at Msajili')
    end

    it 'renders the receiver email' do
      expect(@mail.to).to eql([@user.email])
    end

    it 'renders the sender email' do
      expect(@mail.from).to eql(['no-reply@msajili.com'])
    end

    it 'assigns activation token' do
      expect(@mail.body.encoded).to match ("activation_token=#{@user.activation_token}")
    end

    it 'does not mention as a recruiter' do
      expect(@mail.body.encoded).not_to match ('as a recruiter for')
    end
  end

  describe 'recruiter_activate(user)' do
    before do
      company = create(:company)
      @recruiter = company.get_recruiters.first
      @mail = Notifications.recruiter_activate(@recruiter)
    end

    it 'renders the subject' do
      expect(@mail.subject).to eql('Account activation at Msajili')
    end

    it 'renders the receiver email' do
      expect(@mail.to).to eql([@recruiter.email])
    end

    it 'renders the sender email' do
      expect(@mail.from).to eql(['no-reply@msajili.com'])
    end

    it 'mentions as a recruiter' do
      expect(@mail.body.encoded).to match ('as a recruiter for')
    end

    it 'assigns activation token' do
      expect(@mail.body.encoded).to match ("activation_token=#{@recruiter.activation_token}")
    end
  end

  describe 'forgot_password(pwd_rqst)' do
    before do
      @user = create(:applicant)
      @password_request = create(:password_request,user: @user)
      @mail = Notifications.forgot_password(@password_request)
    end

    it 'renders the subject' do
      expect(@mail.subject).to eql('Password reset instructions')
    end

    it 'renders the receiver email' do
      expect(@mail.to).to eql([@user.email])
    end

    it 'renders the sender email' do
      expect(@mail.from).to eql(['no-reply@msajili.com'])
    end

    it 'assigns token' do
      expect(@mail.body.encoded).to match ("token=#{@password_request.token}")
    end
  end

end
