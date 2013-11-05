class AddMessageToCourse < ActiveRecord::Migration
  def change
    add_column :courses, :message, :text
  end
end
