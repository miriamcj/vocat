class MigrateCourseSettingsToProjectSettings < ActiveRecord::Migration

  def up
    add_column :projects, :settings, :hstore, default: '', null: false
    sql = 'SELECT settings, id FROM courses'
    results = ActiveRecord::Base.connection.execute(sql)
    results.ntuples.times do |i|
      row = results[i]
      settings = row['settings']
      update_sql = "UPDATE projects SET settings = #{ActiveRecord::Base.connection.quote(settings)} WHERE course_id = #{row['id']}"
      puts update_sql
      ActiveRecord::Base.connection.execute(update_sql)
    end
    rename_column :courses, :settings, :settings_to_delete
  end

  def down
    rename_column :courses, :settings_to_delete, :settings
    remove_column :projects, :settings, :hstore
  end

end
