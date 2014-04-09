class SetAllProjectTypesToAny < ActiveRecord::Migration
  def change
    Project.update_all(:project_type => 'any')
  end
end
