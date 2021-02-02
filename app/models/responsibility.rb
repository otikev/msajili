# == Schema Information
#
# Table name: responsibilities
#
#  id          :bigint           not null, primary key
#  description :text
#  employer_id :bigint
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_responsibilities_on_employer_id  (employer_id)
#



class Responsibility < ApplicationRecord
  require 'utils'
  belongs_to :employer
end
