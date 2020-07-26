class RemoveLevelFromAcademicQualifications < ActiveRecord::Migration
  def change
    remove_column :academic_qualifications, :level
    change_table :academic_qualifications do |t|
      t.belongs_to :academic_level
    end
  end
end
