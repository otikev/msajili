class RenameOrderToPosition < ActiveRecord::Migration
  def change
    rename_column :stages, :order, :position
  end
end
