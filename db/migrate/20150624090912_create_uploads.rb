class CreateUploads < ActiveRecord::Migration
  def change
    create_table :uploads do |t|
      t.integer :type
      t.string :description
      t.string :url
      t.string :file
      t.belongs_to :user

      t.timestamps
    end
  end
end
