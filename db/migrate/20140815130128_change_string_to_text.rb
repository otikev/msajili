class ChangeStringToText < ActiveRecord::Migration[6.0]
  def change
    change_column :responsibilities, :description, :text
  end
end
