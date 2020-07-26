# == Schema Information
#
# Table name: password_requests
#
#  id         :integer          not null, primary key
#  token      :string(255)
#  expiry     :datetime
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#



require 'rails_helper'

RSpec.describe PasswordRequest, :type => :model do
  it 'has a valid factory' do
    expect(build(:password_request)).to be_valid
  end

  it 'is invalid without a user' do
    password_request = build(:password_request,user: nil)
    expect(password_request).not_to be_valid
  end

  it 'is invalid without a token' do
    password_request = build(:password_request,token: nil)
    expect(password_request).not_to be_valid
  end

  it 'is invalid without expiry' do
    password_request = build(:password_request,expiry: nil)
    expect(password_request).not_to be_valid
  end
end


describe PasswordRequest, '#change_password(password,password_confirmation)' do
  before do
    @password_request = create(:password_request)
  end

  context 'when password and confirmation do not match' do
    it 'should fail with error' do
      @password_request.change_password('111111111','2222222222')
      expect(@password_request.errors.any?).to eq true
      user = @password_request.user
      expect(user.authenticate('12345',false)).to eq user #password didn't change
    end
  end

  context 'when password and confirmation match' do
    it 'and password is too short it should fail' do
      @password_request.change_password('1234','1234')
      expect(@password_request.errors.any?).to eq true
      user = @password_request.user
      expect(user.authenticate('12345',false)).to eq user #password didn't change
    end
  end

  it 'has valid password and confirmation' do
    @password_request.change_password('newvalidpassword','newvalidpassword')
    expect(@password_request.errors.any?).to eq false
    user = @password_request.user
    expect(user.authenticate('12345',false)).not_to eq user
    expect(user.authenticate('newvalidpassword',false)).to eq user #password changed
  end
end

describe PasswordRequest, '.delete_expired_requests' do
  before do
    2.times do
      create(:password_request,:expired)
    end
    create(:password_request)
  end

  it 'deletes expired requests only' do
    expect(PasswordRequest.delete_expired_requests).to eq 2
  end
end

describe PasswordRequest, '.send_password_reset(email)' do
  before do
    Delayed::Worker.delay_jobs = false
    @user = create(:applicant)
  end

  after do
    Delayed::Worker.delay_jobs = true
  end

  it 'sends a password reset email' do
    expect{PasswordRequest.send_password_reset(@user.email)}.to change {ActionMailer::Base.deliveries.count}.by(1)
  end
end
