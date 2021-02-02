class AddTemplateIdToQuestions < ActiveRecord::Migration[6.0]
  def change
    add_column :questions, :template_id, :integer
  end
end
