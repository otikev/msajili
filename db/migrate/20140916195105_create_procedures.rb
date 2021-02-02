class CreateProcedures < ActiveRecord::Migration
  def change
    create_table :procedures do |t|
      t.string :title
      t.belongs_to :company

      t.timestamps
    end
  end
end
