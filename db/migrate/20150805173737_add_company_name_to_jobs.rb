class AddCompanyNameToJobs < ActiveRecord::Migration[6.0]
  def change
    add_column :jobs, :company_name, :string
  end
end
