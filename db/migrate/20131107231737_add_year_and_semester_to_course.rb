class AddYearAndSemesterToCourse < ActiveRecord::Migration
  def change
    add_column :courses, :year, :integer
    add_column :courses, :semester, :string
  end
end
