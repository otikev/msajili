class DropPackages < ActiveRecord::Migration
  def change
    drop_table :packages
    rename_column :companies, :package_id, :package
  end
end
