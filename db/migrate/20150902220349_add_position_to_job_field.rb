class AddPositionToJobField < ActiveRecord::Migration[6.0]
  #read more here : http://railsguides.net/change-data-in-migrations-like-a-boss/
  class JobField < ActiveRecord::Base
  end

  def change
    add_column :job_fields, :position, :integer
    JobField.find_each do |field|
      field.position = field.id
      field.save!
    end
  end
end
