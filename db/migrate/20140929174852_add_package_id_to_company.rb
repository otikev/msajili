class AddPackageIdToCompany < ActiveRecord::Migration[6.0]
  def change
    add_column :companies, :package_id, :integer
  end
end
