class RemoveOngoingFromAcademicQualifications < ActiveRecord::Migration
  def change
    remove_column :academic_qualifications, :ongoing
  end
end
