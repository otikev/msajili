class CreateSchedulerLogs < ActiveRecord::Migration
  def change
    create_table :scheduler_logs do |t|
      t.string :scheduler

      t.timestamps
    end
  end
end
