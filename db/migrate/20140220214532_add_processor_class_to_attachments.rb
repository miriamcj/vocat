class AddProcessorClassToAttachments < ActiveRecord::Migration
  def change
    add_column :attachments, :processor_class, :string
  end
end
