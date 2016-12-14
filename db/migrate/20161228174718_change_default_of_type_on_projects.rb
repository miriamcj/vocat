class ChangeDefaultOfTypeOnProjects < ActiveRecord::Migration[5.0]
  def up
    change_column_default :projects, :type, "UserProject"
  end

  def down
    change_column_default :projects, :type, "user"
  end
end
