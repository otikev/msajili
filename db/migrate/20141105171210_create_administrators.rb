class CreateAdministrators < ActiveRecord::Migration
  def change
    create_table :administrators do |t|
      t.string :email, :unique => true
      t.string :first_name
      t.string :last_name
      t.string :password_hash
      t.string :password_salt
      t.string :auth_token, :unique => true

      t.timestamps
    end
  end
end
