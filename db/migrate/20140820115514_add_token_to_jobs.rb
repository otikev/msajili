class AddTokenToJobs < ActiveRecord::Migration[6.0]
  def change
    add_column :jobs, :token, :string
  end
end
