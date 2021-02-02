class AddDroppedValueToApplication < ActiveRecord::Migration
  def change
    change_column :applications, :dropped, :boolean, :default => false
  end
end
