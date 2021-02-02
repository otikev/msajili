class CreateSchedulerLogs < ActiveRecord::Migration[6.0]
  def change
    create_table :scheduler_logs do |t|
      t.string :scheduler

      t.timestamps
    end
  end
end
