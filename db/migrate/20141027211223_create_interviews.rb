class CreateInterviews < ActiveRecord::Migration
  def change
    create_table :interviews do |t|
      t.datetime :start_time
      t.datetime :end_time
      t.string :location
      t.text :additional_info
      t.text :comments
      t.belongs_to :user
      t.belongs_to :application

      t.timestamps
    end
  end
end
