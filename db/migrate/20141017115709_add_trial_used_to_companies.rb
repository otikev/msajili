class AddTrialUsedToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :trial_used, :integer, :default => 0
  end
end
