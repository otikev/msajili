class AddPositionToReferees < ActiveRecord::Migration
  def change
    add_column :referees, :position, :string
  end
end
