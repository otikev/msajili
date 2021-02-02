class AddEnabledToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :enabled, :boolean, :default => false
  end
end
