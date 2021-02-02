class CreateCommissions < ActiveRecord::Migration
  def change
    create_table :commissions do |t|
      t.float :amount
      t.belongs_to :sales_agent
      t.belongs_to :payment
      t.belongs_to :company

      t.timestamps
    end
  end
end
