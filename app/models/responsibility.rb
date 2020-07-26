# == Schema Information
#
# Table name: responsibilities
#
#  id          :integer          not null, primary key
#  description :text
#  employer_id :integer
#  created_at  :datetime
#  updated_at  :datetime
#



class Responsibility < ActiveRecord::Base
  require 'utils'
  belongs_to :employer
end
