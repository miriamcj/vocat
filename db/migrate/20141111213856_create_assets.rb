class CreateAssets < ActiveRecord::Migration
  def change
    create_table :assets do |t|
      t.string :type
      t.string :name
      t.integer :author_id
      t.integer :submission_id
      t.integer :listing_order
      t.string :external_id
    end
  end
end
