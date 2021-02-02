# == Schema Information
#
# Table name: academic_qualifications
#
#  id                :bigint           not null, primary key
#  institution       :string
#  award             :string
#  user_id           :bigint
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  academic_level_id :bigint
#  start_date        :date
#  end_date          :date
#
# Indexes
#
#  index_academic_qualifications_on_academic_level_id  (academic_level_id)
#  index_academic_qualifications_on_user_id            (user_id)
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
