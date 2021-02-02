class CreateSyncLogs < ActiveRecord::Migration[6.0]
  def change
    create_table :sync_logs do |t|
      t.integer :record_type
      t.integer :record_id
      t.integer :log_type

      t.timestamps
    end
  end
end
