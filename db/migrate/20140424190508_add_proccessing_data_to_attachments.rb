class AddProccessingDataToAttachments < ActiveRecord::Migration
  def change
    add_column :attachments, :processing_data, :hstore
  end
end
