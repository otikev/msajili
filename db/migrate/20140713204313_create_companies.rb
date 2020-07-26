class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.string :name
      t.text :about
      t.string :phone
      t.string :country
      t.string :city
      t.belongs_to :user
      
      t.timestamps
    end
  end
end
