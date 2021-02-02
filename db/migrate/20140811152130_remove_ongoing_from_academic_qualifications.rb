class RemoveOngoingFromAcademicQualifications < ActiveRecord::Migration[6.0]
  def change
    remove_column :academic_qualifications, :ongoing
  end
end
