class AddApplicationToUpload < ActiveRecord::Migration
  def change
    add_column :uploads, :application_id, :integer
  end
end
