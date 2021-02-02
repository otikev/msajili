class RenameTypeToUploadType < ActiveRecord::Migration
  def change
    rename_column :uploads, :type, :upload_type
  end
end
