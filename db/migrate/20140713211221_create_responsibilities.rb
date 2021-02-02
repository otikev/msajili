class CreateResponsibilities < ActiveRecord::Migration[6.0]
  def change
    create_table :responsibilities do |t|
      t.string :description
      t.belongs_to :employer
      
      t.timestamps
    end
  end
end
