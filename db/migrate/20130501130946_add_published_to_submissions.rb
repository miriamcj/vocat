class AddPublishedToSubmissions < ActiveRecord::Migration
  def change
    add_column :submissions, :published, :boolean
  end
end
