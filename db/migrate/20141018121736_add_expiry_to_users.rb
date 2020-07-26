class AddExpiryToUsers < ActiveRecord::Migration
  def change
    add_column :users, :expiry, :date
  end
end
