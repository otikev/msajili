# == Schema Information
#
# Table name: academic_levels
#
#  id          :bigint           not null, primary key
#  description :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#



class AcademicLevel < ApplicationRecord
  require "utils"
  has_many :academic_qualifications

  def name
    "#{description}"
  end

end
