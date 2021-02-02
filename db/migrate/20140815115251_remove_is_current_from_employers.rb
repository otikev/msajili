class RemoveIsCurrentFromEmployers < ActiveRecord::Migration
  def change
    remove_column :employers, :is_current
  end
end
