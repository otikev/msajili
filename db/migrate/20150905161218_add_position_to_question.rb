class AddPositionToQuestion < ActiveRecord::Migration
  #read more here : http://railsguides.net/change-data-in-migrations-like-a-boss/
  class Question < ActiveRecord::Base
  end

  def change
    add_column :questions, :position, :integer
    add_column :questions, :question_type, :integer, :default => 0
    Question.find_each do |question|
      question.position = question.id
      question.save!
    end
  end
end
