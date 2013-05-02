class AddSettingsToCourse < ActiveRecord::Migration
  def change
    add_column :courses, :settings, :hstore
  end
end
