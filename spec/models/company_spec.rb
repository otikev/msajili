# == Schema Information
#
# Table name: companies
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  about       :text
#  phone       :string(255)
#  country     :string(255)
#  city        :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#  website     :string(255)
#  package     :integer
#  trial_used  :integer          default(0)
#  referral_id :string(255)
#  identifier  :string(255)
#


require 'rails_helper'
require 'faker'

describe Company do
  it 'has a valid factory' do
    expect(build(:company)).to be_valid
  end
  it 'must have a package' do
    expect(build(:company,:no_package)).not_to be_valid
  end
  it 'must have a valid package' do
    expect(build(:company,:invalid_package)).not_to be_valid
  end
  it 'must have a valid website' do
    expect(build(:company,:invalid_website)).not_to be_valid
  end
end

describe Company, '#country_name' do
  it 'returns correct full country name' do
   valid = build(:company, country: 'KE')
   expect(valid.country_name).to eq 'Kenya'
  end
end
