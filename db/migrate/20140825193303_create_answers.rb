class CreateAnswers < ActiveRecord::Migration[6.0]
  def change
    create_table :answers do |t|
      t.text :content
      t.belongs_to :question
      t.belongs_to :application
      t.belongs_to :choice
      
      t.timestamps
    end
  end
end
