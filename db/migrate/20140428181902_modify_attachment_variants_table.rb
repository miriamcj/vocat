class ModifyAttachmentVariantsTable < ActiveRecord::Migration
  def change
    rename_column :attachment_variants, :type, :format
  end
end
