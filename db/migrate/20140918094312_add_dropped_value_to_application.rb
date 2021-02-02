class AddDroppedValueToApplication < ActiveRecord::Migration[6.0]
  def change
    change_column :applications, :dropped, :boolean, :default => false
  end
end
