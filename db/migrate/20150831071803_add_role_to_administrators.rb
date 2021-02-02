class AddRoleToAdministrators < ActiveRecord::Migration[6.0]
  def change
    add_column :administrators, :role, :integer, :default => 1
    add_column :administrators, :enabled, :boolean, :default => true
  end
end
