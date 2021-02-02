class CreateAcademicLevels < ActiveRecord::Migration[6.0]
  def change
    create_table :academic_levels do |t|
      t.string :description, :unique => true
      
      t.timestamps
    end
  end
end
