class CreateStages < ActiveRecord::Migration[6.0]
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
