class CreateComments < ActiveRecord::Migration[6.0]
  def change
    create_table :comments do |t|
      t.text :message
      t.belongs_to :application
      t.belongs_to :user
      t.belongs_to :stage
      
      t.timestamps
    end
  end
end
