class DropPackages < ActiveRecord::Migration[6.0]
  def change
    drop_table :packages
    rename_column :companies, :package_id, :package
  end
end
