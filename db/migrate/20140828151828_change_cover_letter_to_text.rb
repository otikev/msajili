class ChangeCoverLetterToText < ActiveRecord::Migration[6.0]
  def change
    change_column :applications, :cover_letter, :text
  end
end
