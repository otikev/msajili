# == Schema Information
#
# Table name: referees
#
#  id         :integer          not null, primary key
#  first_name :string(255)
#  last_name  :string(255)
#  phone      :string(255)
#  company    :string(255)
#  title      :string(255)
#  email      :string(255)
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#  position   :string(255)
#



class Referee < ActiveRecord::Base
  require 'utils'
  belongs_to :user
end
