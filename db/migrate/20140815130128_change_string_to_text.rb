class ChangeStringToText < ActiveRecord::Migration
  def change
    change_column :responsibilities, :description, :text
  end
end
