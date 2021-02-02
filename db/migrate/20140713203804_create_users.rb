class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :email, :unique => true
      t.string :country
      t.string :city
      t.string :password_hash
      t.string :password_salt
      t.string :auth_token, :unique => true
      t.belongs_to :company
      t.belongs_to :role
      
      t.timestamps
    end
  end
end
