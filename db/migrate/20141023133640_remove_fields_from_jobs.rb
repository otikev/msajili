class RemoveFieldsFromJobs < ActiveRecord::Migration
  def change
    remove_column :jobs, :base_salary
    remove_column :jobs, :salary_currency
    remove_column :jobs, :salary_negotiable
    remove_column :jobs, :benefits
    remove_column :jobs, :responsibilities
    remove_column :jobs, :education_requirements
    remove_column :jobs, :experience_requirements
    remove_column :jobs, :skills
    remove_column :jobs, :work_hours
    remove_column :jobs, :reporting_to
    remove_column :jobs, :duration
  end
end
