class AddColumnsToJobsAndCompanies < ActiveRecord::Migration[6.0]
  def change
    add_column :companies, :website, :string
    add_column :jobs, :reporting_to, :string
    add_column :jobs, :duration, :string
  end
end
