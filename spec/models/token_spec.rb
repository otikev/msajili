# == Schema Information
#
# Table name: tokens
#
#  id         :integer          not null, primary key
#  jobs       :integer
#  expiry     :date
#  company_id :integer
#  created_at :datetime
#  updated_at :datetime
#




require 'rails_helper'

RSpec.describe Token, :type => :model do

  it 'has a valid factory' do
    token = build(:token)
    expect(token).to be_valid
  end

  it 'is invalid if no company' do
    token = build(:token,company:nil)
    expect(token).not_to be_valid
  end
end

describe Token, '#reset' do
  before do
    @token = create(:token)
  end

  it 'should reset values' do
    expect(@token.jobs).to eq 15
    expect(@token.expiry).to eq (Date.today + 5.days).to_date
    @token.reset
    expect(@token.jobs).to eq 0
    expect(@token.expiry).to eq (Date.today - 1.days).to_date
  end
end

describe Token, '#add_jobs(n)' do
  before do
    @token = create(:token)
  end

  it 'should increment jobs' do
    val = @token.jobs
    @token.add_jobs(3)
    expect(@token.jobs).to eq (val+3)
  end
end

describe Token, '#extend_expiry(months)' do
  before do
    @token = create(:token)
  end

  it 'should increase expiry date' do
    current_expiry = @token.expiry
    @token.extend_expiry(1)
    expect(@token.expiry).to eq (current_expiry+31).to_date
  end
end

describe Token, '#days_to_expiry' do
  before do
    @token = create(:token,expiry: (Date.today + 21.days).to_date)
  end

  it 'should return correct value' do
    expect(@token.days_to_expiry).to eq 21
  end
end

describe Token, '#is_expired' do
  before do
    @token = create(:token,expiry: (Date.today + 21.days).to_date)
    @token_expired = create(:token,expiry: (Date.today).to_date)
  end

  it 'should return correct value' do
    expect(@token.is_expired).to eq false
    expect(@token_expired.is_expired).to eq true
  end
end

describe Token, '#apply_trial' do
  before do
    company_free = create(:company)
    company_on_demand = create(:company,:on_demand_package)
    company_premium = create(:company,:premium_package)
    @token_free = create(:token,company: company_free)
    @token_on_demand = create(:token,company: company_on_demand)
    @token_premium = create(:token,company: company_premium)
  end

  it 'should do nothing for free package' do
    @token_free.reset
    @token_free.apply_trial
    expect(@token_free.company.trial_used).to eq 0
    expect(@token_free.jobs).to eq 0
    expect(@token_free.expiry).to eq (Date.today - 1.days).to_date
  end

  it 'should set 1 job for on-demand package' do
    @token_on_demand.reset
    @token_on_demand.apply_trial
    expect(@token_on_demand.company.trial_used).to eq 1
    expect(@token_on_demand.jobs).to eq 1
    expect(@token_on_demand.expiry).to eq (Date.today - 1.days).to_date
  end

  it 'should set 30 days for premium package' do
    @token_premium.reset
    @token_premium.apply_trial
    expect(@token_premium.company.trial_used).to eq 1
    expect(@token_premium.jobs).to eq 0
    expect(@token_premium.expiry).to eq (Date.today + 30.days).to_date
  end

end
