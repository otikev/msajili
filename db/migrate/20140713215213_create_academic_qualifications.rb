class CreateAcademicQualifications < ActiveRecord::Migration
  def change
    create_table :academic_qualifications do |t|
      t.string :level
      t.string :start_date
      t.string :end_date
      t.integer :ongoing
      t.string :institution
      t.string :award
      t.belongs_to :user
      
      t.timestamps
    end
  end
end
