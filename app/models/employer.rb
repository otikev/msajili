# == Schema Information
#
# Table name: employers
#
#  id            :bigint           not null, primary key
#  name          :string
#  from          :date
#  to            :date
#  position_held :string
#  user_id       :bigint
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_employers_on_user_id  (user_id)
#



class Employer < ApplicationRecord
  require 'utils'
  belongs_to :user
  has_many :responsibilities,:dependent => :destroy

  accepts_nested_attributes_for :responsibilities, :allow_destroy => true
end
