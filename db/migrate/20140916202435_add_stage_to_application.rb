class AddStageToApplication < ActiveRecord::Migration[6.0]
  def change
    add_column :applications, :stage_id, :integer
    add_column :applications, :dropped, :boolean
  end
end
