class AddVideoIdToAnnotations < ActiveRecord::Migration
  def change
    add_column :annotations, :video_id, :integer
    remove_column :annotations, :attachment_id
  end
end
