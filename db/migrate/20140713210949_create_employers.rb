class CreateEmployers < ActiveRecord::Migration[6.0]
  def change
    create_table :employers do |t|
      t.string :name
      t.date :from
      t.date :to
      t.integer :is_current
      t.string :position_held
      t.belongs_to :user
      
      t.timestamps
    end
  end
end
