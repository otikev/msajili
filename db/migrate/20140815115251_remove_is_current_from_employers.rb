class RemoveIsCurrentFromEmployers < ActiveRecord::Migration[6.0]
  def change
    remove_column :employers, :is_current
  end
end
