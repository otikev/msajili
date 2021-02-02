class AddExpiryToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :expiry, :date
  end
end
