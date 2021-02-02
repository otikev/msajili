class AddTemplateIdToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :template_id, :integer
  end
end
