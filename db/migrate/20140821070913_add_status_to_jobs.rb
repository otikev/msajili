class AddStatusToJobs < ActiveRecord::Migration[6.0]
  def change
    add_column :jobs, :status, :integer
  end
end
