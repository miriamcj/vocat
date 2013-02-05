class CreateVideos < ActiveRecord::Migration
  def change
    create_table :videos do |t|
      t.string :name
      t.string :path
      t.text :description
      t.date :upload_date

      t.timestamps
    end
  end
end
