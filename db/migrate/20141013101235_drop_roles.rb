class DropRoles < ActiveRecord::Migration[6.0]
  def change
    drop_table :roles
    rename_column :users, :role_id, :role
  end
end
