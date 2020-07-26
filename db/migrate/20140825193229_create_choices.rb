class CreateChoices < ActiveRecord::Migration
  def change
    create_table :choices do |t|
      t.text :content
      t.belongs_to :question
      t.timestamps
    end
  end
end
