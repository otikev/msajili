class CreateSalesAgents < ActiveRecord::Migration[6.0]
  def change
    create_table :sales_agents do |t|
      t.string :first_name
      t.string :last_name
      t.string :email,:unique => true
      t.string :auth_token,:unique => true
      t.string :password_hash
      t.string :password_salt
      t.string :referral_id,:unique => true

      t.timestamps
    end
  end
end
