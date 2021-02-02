class CreateAgentRequests < ActiveRecord::Migration[6.0]
  def change
    create_table :agent_requests do |t|
      t.string :first_name
      t.string :last_name
      t.string :phone
      t.string :email, :unique => true

      t.timestamps
    end
  end
end
