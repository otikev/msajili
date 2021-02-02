# == Schema Information
#
# Table name: employers
#
#  id            :integer          not null, primary key
#  name          :string(255)
#  from          :date
#  to            :date
#  position_held :string(255)
#  user_id       :integer
#  created_at    :datetime
#  updated_at    :datetime
#



class Employer < ApplicationRecord
  require 'utils'
  belongs_to :user
  has_many :responsibilities,:dependent => :destroy

  accepts_nested_attributes_for :responsibilities, :allow_destroy => true
end
