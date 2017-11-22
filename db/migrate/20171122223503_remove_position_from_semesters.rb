class RemovePositionFromSemesters < ActiveRecord::Migration[5.0]
  def change
    remove_column :semesters, :position
  end
end
