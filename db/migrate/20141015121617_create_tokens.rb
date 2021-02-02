class CreateTokens < ActiveRecord::Migration[6.0]
  def change
    create_table :tokens do |t|
      t.integer :jobs
      t.date :expiry
      t.belongs_to :company

      t.timestamps
    end
  end
end
