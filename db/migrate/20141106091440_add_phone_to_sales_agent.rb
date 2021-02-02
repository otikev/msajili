class AddPhoneToSalesAgent < ActiveRecord::Migration
  def change
    add_column :sales_agents, :phone, :string
  end
end
