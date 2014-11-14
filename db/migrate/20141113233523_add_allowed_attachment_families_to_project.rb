class AddAllowedAttachmentFamiliesToProject < ActiveRecord::Migration
  def change
    add_column :projects, :allowed_attachment_families, :string
  end
end
