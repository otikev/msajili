# == Schema Information
#
# Table name: academic_levels
#
#  id          :integer          not null, primary key
#  description :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#



class AcademicLevel < ApplicationRecord
  require "utils"
  has_many :academic_qualifications

  def name
    "#{description}"
  end

end
