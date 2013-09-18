class CreateVideos < ActiveRecord::Migration
  def up
    create_table :videos do |t|
      t.string :name
      t.string :url
      t.string :source_id
      t.string :source_url
      t.string :source
      t.integer :submission_id
      t.datetime :created_at
      t.datetime :updated_at
    end
  end

  def down
    drop_table :videos
  end
end
