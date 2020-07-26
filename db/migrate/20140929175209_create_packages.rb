class CreatePackages < ActiveRecord::Migration
  def change
    create_table :packages do |t|
      t.text :description
      t.integer :monthly_fee
      
      t.timestamps
    end
  end
end
