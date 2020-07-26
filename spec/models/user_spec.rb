# == Schema Information
#
# Table name: users
#
#  id               :integer          not null, primary key
#  first_name       :string(255)
#  last_name        :string(255)
#  email            :string(255)
#  country          :string(255)
#  city             :string(255)
#  password_hash    :string(255)
#  password_salt    :string(255)
#  auth_token       :string(255)
#  company_id       :integer
#  role             :integer
#  created_at       :datetime
#  updated_at       :datetime
#  activated        :boolean          default(FALSE)
#  activation_token :string(255)
#  expiry           :date
#  enabled          :boolean          default(FALSE)
#


require 'rails_helper'
require 'faker'

describe User do
  it 'has a valid factory' do
    expect(create(:applicant)).to be_valid
  end
  it 'is invalid without an email' do
    expect(build(:applicant, email: nil)).not_to be_valid
  end
  it 'is invalid if admin without a company' do
    expect(build(:admin , company_id: nil)).not_to be_valid
  end
  it 'is invalid if recruiter without a company' do
    expect(build(:recruiter, company_id: nil)).not_to be_valid
  end
  it 'is invalid if applicant with a company' do
    expect(build(:applicant, company_id: Faker::Number.number(3))).not_to be_valid
  end
end

describe User, '#country_name' do
  it 'returns correct full country name' do
   valid = build(:applicant, country: 'KE')
   expect(valid.country_name).to eq 'Kenya'
  end
end

describe User, '#authenticate(pass)' do
  before do
    @user = create(:applicant)
  end
  
  it 'passes with valid password' do
    expect(@user.authenticate('12345',false)).to eq @user
  end
  
  it 'fails with invalid password' do
    expect(@user.authenticate('123456',false)).to eq nil
  end

  it 'generates new auth_token' do
    old_token = @user.auth_token
    @user.authenticate('12345',true)
    expect(@user.auth_token).not_to eql(old_token)
  end
end

describe User, '#send_activate' do
  before do
    Delayed::Worker.delay_jobs = false
    @user_not_activated = create(:applicant, :not_activated)
    @user_activated = create(:applicant, :activated)
  end

  after do
    Delayed::Worker.delay_jobs = true
  end

  context 'when not activated' do
    it 'should send activation email' do
      expect(@user_not_activated.activated).to eq false
      expect{@user_not_activated.send_activate}.to change {ActionMailer::Base.deliveries.count}.by(1)
    end
  end

  context 'when activated' do
    it 'should not send activation email' do
      expect(@user_activated.activated).to eq true
      expect{@user_activated.send_activate}.to change {ActionMailer::Base.deliveries.count}.by(0)
    end
  end
end

describe User, '#send_recruiter_activate' do
  before do
    Delayed::Worker.delay_jobs = false
    company = create(:company,activated: true)
    @recruiter_activated = company.get_recruiters.first
    company2 = create(:company,activated: false)
    @recruiter_not_activated = company2.get_recruiters.first
  end

  after do
    Delayed::Worker.delay_jobs = true
  end

  context 'when not activated' do
    it 'should send activation email' do
      expect(@recruiter_not_activated.activated).to eq false
      expect{@recruiter_not_activated.send_recruiter_activate}.to change {ActionMailer::Base.deliveries.count}.by(1)
    end
  end

  context 'when activated' do
    it 'should not send activation email' do
      expect(@recruiter_activated.activated).to eq true
      expect{@recruiter_activated.send_recruiter_activate}.to change {ActionMailer::Base.deliveries.count}.by(0)
    end
  end
end

describe User, '#change_password(new_password)' do
  before do
    @user = create(:applicant)
  end

  it 'updates a user password' do
    expect(@user.authenticate('12345',false)).to eq @user
    @user.change_password('newpassword','newpassword')
    expect(@user.authenticate('newpassword',false)).to eq @user
  end

  it 'fails if password is too short' do
    @user.change_password('12345','12345')
    expect(@user).to be_valid
    @user.change_password('1234','1234')
    expect(@user).not_to be_valid
  end

  it 'fails if password and confirmation do not match' do
    @user.change_password('123456','123458')
    expect(@user.authenticate('12345',false)).to eq @user
  end
end

describe User, '.delete_expired_unactivated_accounts' do
  before do
    2.times do
      create(:applicant,:expired_not_activated)
    end
    create(:applicant,:expired_activated)
  end

  it 'deletes expired unactivated users only' do
    expect(User.delete_expired_unactivated_accounts).to eq 2
  end
end

describe User, '#activate?' do
  before do
    @user = create(:applicant, activated: false)
  end

  it 'marks a user as activated' do
    expect(@user.activated).to eq false
    expect(@user.activate?).to eq true
  end
end
