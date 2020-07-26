class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.string :description
      t.integer :quantity
      t.integer :package
      t.integer :status
      t.integer :total
      t.string :pesapal_transaction_tracking_id
      t.string :pesapal_merchant_reference
      t.belongs_to :company

      t.timestamps
    end
  end
end
