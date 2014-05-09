class AddStiToProjects < ActiveRecord::Migration
  def change

    rename_column :projects, :project_type, :type

    reversible do |direction|
      direction.up do
        Project.connection.execute("UPDATE projects SET type='UserProject' WHERE projects.type = 'user'")
        Project.connection.execute("UPDATE projects SET type='GroupProject' WHERE projects.type = 'group'")
        Project.connection.execute("UPDATE projects SET type='OpenProject' WHERE projects.type = 'any'")
      end

      direction.down do
        Project.connection.execute("UPDATE projects SET type='user' WHERE projects.type = 'UserProject'")
        Project.connection.execute("UPDATE projects SET type='group' WHERE projects.type = 'GroupProject'")
        Project.connection.execute("UPDATE projects SET type='any' WHERE projects.type = 'OpenProject'")
      end
    end


  end
end
