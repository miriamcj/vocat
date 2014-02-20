class AddProcessingErrorToAttachments < ActiveRecord::Migration
  def change
    add_column :attachments, :processing_error, :string
  end
end
