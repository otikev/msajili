class AddUniquenessToEmail < ActiveRecord::Migration
  def change
    remove_index :users, [:email,:role_id]
    change_column :users, :email, :string, :unique => true
  end
end
