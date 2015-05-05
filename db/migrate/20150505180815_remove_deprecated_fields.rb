class RemoveDeprecatedFields < ActiveRecord::Migration
  def change
    remove_column :annotations, :video_id_to_delete
    remove_column :attachments, :video_id_to_delete
    remove_column :courses, :settings_to_delete
    drop_table :videos_to_delete
    drop_table :courses_assistants_to_be_deleted
    drop_table :courses_creators_to_be_deleted
    drop_table :courses_evaluators_to_be_deleted
  end
end
