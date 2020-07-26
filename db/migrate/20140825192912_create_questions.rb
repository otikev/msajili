class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.text :content
      t.belongs_to :job
      t.timestamps
    end
  end
end
