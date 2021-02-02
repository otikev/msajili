class AddPopularityToJobStat < ActiveRecord::Migration
  def change
    add_column :job_stats, :popularity, :integer, :default => 0
  end
end
