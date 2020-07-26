class CreateStages < ActiveRecord::Migration
  def change
    create_table :stages do |t|
      t.integer :order
      t.string :title
      t.text :description
      t.belongs_to :procedure
      
      t.timestamps
    end
  end
end
