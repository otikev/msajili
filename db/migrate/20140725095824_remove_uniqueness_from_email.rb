class RemoveUniquenessFromEmail < ActiveRecord::Migration[6.0]
  def change
    change_column :users, :email, :string, :unique => false
    add_index :users, [:email,:role_id], :unique => true
  end
end
