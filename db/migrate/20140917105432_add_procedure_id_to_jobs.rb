class AddProcedureIdToJobs < ActiveRecord::Migration
  def change
    add_column :jobs, :procedure_id, :integer
  end
end
