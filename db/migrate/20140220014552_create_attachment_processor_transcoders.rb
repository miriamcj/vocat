class CreateAttachmentProcessorTranscoders < ActiveRecord::Migration
  def change
    create_table :attachment_processor_transcoders do |t|

      t.timestamps
    end
  end
end
