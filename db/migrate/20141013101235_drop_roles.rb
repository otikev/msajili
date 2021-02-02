class DropRoles < ActiveRecord::Migration
  def change
    drop_table :roles
    rename_column :users, :role_id, :role
  end
end
