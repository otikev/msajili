class AddUniquenessToStageOrders < ActiveRecord::Migration[6.0]
  def change
    add_index :stages, [:procedure_id,:order], :unique => true
  end
end
