class CreateAssets < ActiveRecord::Migration
  def change
    create_table :assets do |t|
      t.string :type
      t.string :name
      t.integer :author_id
      t.integer :submission_id
      t.integer :listing_order
      t.string :external_location
      t.string :external_source

      t.timestamps

    end
  end
end
