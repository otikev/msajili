class AddUniquenessToStageOrders < ActiveRecord::Migration
  def change
    add_index :stages, [:procedure_id,:order], :unique => true
  end
end
