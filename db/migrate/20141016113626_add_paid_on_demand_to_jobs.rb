class AddPaidOnDemandToJobs < ActiveRecord::Migration
  def change
    add_column :jobs, :paid_on_demand, :integer, :default => 0
  end
end
