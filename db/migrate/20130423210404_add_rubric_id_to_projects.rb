class AddRubricIdToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :rubric_id, :integer
  end
end
