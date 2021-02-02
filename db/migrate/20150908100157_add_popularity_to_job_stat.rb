class AddPopularityToJobStat < ActiveRecord::Migration[6.0]
  def change
    add_column :job_stats, :popularity, :integer, :default => 0
  end
end
