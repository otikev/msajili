class RemoveLevelFromAcademicQualifications < ActiveRecord::Migration[6.0]
  def change
    remove_column :academic_qualifications, :level
    change_table :academic_qualifications do |t|
      t.belongs_to :academic_level
    end
  end
end
