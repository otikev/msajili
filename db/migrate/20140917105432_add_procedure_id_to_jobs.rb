class AddProcedureIdToJobs < ActiveRecord::Migration[6.0]
  def change
    add_column :jobs, :procedure_id, :integer
  end
end
