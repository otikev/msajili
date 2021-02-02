class RenameTypeToUploadType < ActiveRecord::Migration[6.0]
  def change
    rename_column :uploads, :type, :upload_type
  end
end
