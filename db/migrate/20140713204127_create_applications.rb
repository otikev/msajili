class CreateApplications < ActiveRecord::Migration[6.0]
  def change
    create_table :applications do |t|
      t.string :cover_letter
      t.belongs_to :job
      t.belongs_to :user
      
      t.timestamps
    end
    add_index :applications, [:job_id,:user_id], :unique => true
  end
end
