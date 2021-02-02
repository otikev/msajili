class AddApplicationToUpload < ActiveRecord::Migration[6.0]
  def change
    add_column :uploads, :application_id, :integer
  end
end
