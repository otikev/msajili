class CreateFilters < ActiveRecord::Migration
  def change
    create_table :filters do |t|
      t.string :title
      t.belongs_to :job
      
      t.timestamps
    end
    
    add_column :answers, :filter_id, :integer
  end
end
