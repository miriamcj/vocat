class AddDefaultsToHstores < ActiveRecord::Migration
  def change
    change_column :evaluations, :scores, :hstore, default: '', null: false
    change_column :courses, :settings, :hstore, default: '', null: false
  end
end
