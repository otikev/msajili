class CreateJobs < ActiveRecord::Migration[6.0]
  def change
    create_table :jobs do |t|
      t.string :title
      t.integer :base_salary
      t.string :salary_currency
      t.integer :salary_negotiable
      t.text :benefits
      t.text :responsibilities
      t.text :education_requirements
      t.text :experience_requirements
      t.text :skills
      t.string :work_hours
      t.date :deadline
      t.string :country
      t.string :city
      t.belongs_to :company
      t.belongs_to :category
      
      t.timestamps
    end
  end
end
