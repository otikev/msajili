class AddPositionToReferees < ActiveRecord::Migration[6.0]
  def change
    add_column :referees, :position, :string
  end
end
