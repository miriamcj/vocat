class ChangeAnnotationSecondsToFloats < ActiveRecord::Migration
  def up
    change_column :annotations, :seconds_timecode, :float
  end

  def down
    change_column :annotations, :seconds_timecode, :integer
  end
end
