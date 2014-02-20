class DropAttachmentProcessorTranscoders < ActiveRecord::Migration
  def change
    drop_table :attachment_processor_transcoders
  end
end
