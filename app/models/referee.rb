# == Schema Information
#
# Table name: referees
#
#  id         :bigint           not null, primary key
#  first_name :string
#  last_name  :string
#  phone      :string
#  company    :string
#  title      :string
#  email      :string
#  user_id    :bigint
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  position   :string
#
# Indexes
#
#  index_referees_on_user_id  (user_id)
#



class Referee < ApplicationRecord
  require 'utils'
  belongs_to :user
end
