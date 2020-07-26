class CreateJobStats < ActiveRecord::Migration
  def change
    create_table :job_stats do |t|
      t.integer :views, :default => 0
      t.belongs_to :job

      t.timestamps
    end
  end
end
