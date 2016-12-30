class AddStartAndEndDatesToSemesters < ActiveRecord::Migration[5.0]
  def change
    add_column :semesters, :start_date, :date
    add_column :semesters, :end_date, :date
  end
end
