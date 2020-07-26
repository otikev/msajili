class ChangeContentToText < ActiveRecord::Migration
  def change
    change_column :job_fields, :content, :text
  end
end
