class RenameOrderToPosition < ActiveRecord::Migration[6.0]
  def change
    rename_column :stages, :order, :position
  end
end
