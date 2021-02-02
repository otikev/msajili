class CreateTokens < ActiveRecord::Migration
  def change
    create_table :tokens do |t|
      t.integer :jobs
      t.date :expiry
      t.belongs_to :company

      t.timestamps
    end
  end
end
