class AddTrialUsedToCompanies < ActiveRecord::Migration[6.0]
  def change
    add_column :companies, :trial_used, :integer, :default => 0
  end
end
