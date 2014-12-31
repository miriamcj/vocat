class AddAllowedAttachmentFamiliesToProject < ActiveRecord::Migration
  def change
    add_column :projects, :allowed_attachment_families, :text, array: true, default: []
  end
end
