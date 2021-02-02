class ChangeContentToText < ActiveRecord::Migration[6.0]
  def change
    change_column :job_fields, :content, :text
  end
end
