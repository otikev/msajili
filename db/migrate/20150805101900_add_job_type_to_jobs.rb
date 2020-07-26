class AddJobTypeToJobs < ActiveRecord::Migration
  def change
    add_column :jobs, :job_type, :integer, :default => 0
  end
end
