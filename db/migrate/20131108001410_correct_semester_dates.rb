class CorrectSemesterDates < ActiveRecord::Migration
  def change
    remove_column :semesters, :start_date
    remove_column :semesters, :end_date
  end
end
