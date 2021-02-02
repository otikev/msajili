class AddSourceToJob < ActiveRecord::Migration[6.0]
  def change
    add_column :jobs, :source, :text
  end
end
