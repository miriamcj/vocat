class CreatePresentations < ActiveRecord::Migration
  def change
    create_table :presentations do |t|
      t.string :name
      t.text :description
      t.attachment :video

      t.timestamps
    end
  end
end
