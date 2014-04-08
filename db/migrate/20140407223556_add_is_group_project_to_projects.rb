class AddIsGroupProjectToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :is_group_project, :boolean, :default => false
  end
end
