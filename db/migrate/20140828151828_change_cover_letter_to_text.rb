class ChangeCoverLetterToText < ActiveRecord::Migration
  def change
    change_column :applications, :cover_letter, :text
  end
end
