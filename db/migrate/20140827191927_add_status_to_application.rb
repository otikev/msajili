class AddStatusToApplication < ActiveRecord::Migration[6.0]
  def change
    add_column :applications, :status, :integer
  end
end
