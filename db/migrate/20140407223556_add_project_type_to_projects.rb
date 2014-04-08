class AddProjectTypeToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :project_type, :string, :default => 'user'
  end
end
