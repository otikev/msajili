class CreateReferees < ActiveRecord::Migration
  def change
    create_table :referees do |t|
      t.string :first_name
      t.string :last_name
      t.string :phone
      t.string :company
      t.string :title
      t.string :email
      t.belongs_to :user
      
      t.timestamps
    end
  end
end
