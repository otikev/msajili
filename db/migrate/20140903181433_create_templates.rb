class CreateTemplates < ActiveRecord::Migration
  def change
    create_table :templates do |t|
      t.string :title
      t.belongs_to :company

      t.timestamps
    end
  end
end
