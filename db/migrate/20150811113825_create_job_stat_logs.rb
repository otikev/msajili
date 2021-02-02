class CreateJobStatLogs < ActiveRecord::Migration[6.0]
  def change
    create_table :job_stat_logs do |t|
      t.belongs_to :job_stat
      t.string :ip_address
      t.text :cookie

      t.timestamps
    end
  end
end
