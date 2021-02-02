class AddPhoneToSalesAgent < ActiveRecord::Migration[6.0]
  def change
    add_column :sales_agents, :phone, :string
  end
end
