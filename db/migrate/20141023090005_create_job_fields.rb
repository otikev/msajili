class CreateJobFields < ActiveRecord::Migration[6.0]
  def change
    create_table :job_fields do |t|
      t.string :title
      t.string :content
      t.belongs_to :job

      t.timestamps
    end
  end
end
