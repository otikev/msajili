class AddPackageIdToCompany < ActiveRecord::Migration
  def change
    add_column :companies, :package_id, :integer
  end
end
