class AdjustSemesterOrdering < ActiveRecord::Migration
  def up
    Semester.where(:name => "Fall").update_all(:position => 4)
    Semester.where(:name => "Summer").update_all(:position => 3)
    Semester.where(:name => "Spring").update_all(:position => 2)
    Semester.where(:name => "Winter").update_all(:position => 1)
  end

  def down
    Semester.where(:name => "Fall").update_all(:position => 1)
    Semester.where(:name => "Summer").update_all(:position => 4)
    Semester.where(:name => "Spring").update_all(:position => 3)
    Semester.where(:name => "Winter").update_all(:position => 2)
  end
end
