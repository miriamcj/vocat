class AddYearToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :year, :integer
  end
end
