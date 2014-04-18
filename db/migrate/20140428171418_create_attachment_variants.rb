class CreateAttachmentVariants < ActiveRecord::Migration
  def change
    create_table :attachment_variants do |t|
      t.integer :attachment_id
      t.string :location
      t.string :type
      t.string :state
      t.string :processor_name
      t.text :processor_data
      t.string :processor_error

      t.timestamps
    end
  end
end
