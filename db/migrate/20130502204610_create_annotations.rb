class CreateAnnotations < ActiveRecord::Migration
  def change
    create_table :annotations do |t|
      t.integer :attachment_id
      t.text :body
      t.string :smpte_timecode
      t.boolean :published
      t.integer :seconds_timecode
      t.integer :author_id

      t.timestamps
    end
  end
end
