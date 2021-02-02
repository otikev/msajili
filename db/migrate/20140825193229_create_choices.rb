class CreateChoices < ActiveRecord::Migration[6.0]
  def change
    create_table :choices do |t|
      t.text :content
      t.belongs_to :question
      t.timestamps
    end
  end
end
