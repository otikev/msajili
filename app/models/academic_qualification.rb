# == Schema Information
#
# Table name: academic_qualifications
#
#  id                :integer          not null, primary key
#  institution       :string(255)
#  award             :string(255)
#  user_id           :integer
#  created_at        :datetime
#  updated_at        :datetime
#  academic_level_id :integer
#  start_date        :date
#  end_date          :date
#



class AcademicQualification < ApplicationRecord
  require "utils"
  belongs_to :user
  belongs_to :academic_level

  validates :start_date, :presence => true
  validates :institution, :presence => true
  validates :award, :presence => true

  def academic_qualification_params
    params.require(:academic_qualification).permit(:start_date,:end_date,:ongoing,:institution,:award,:user_id,:academic_level_id)
  end
end
