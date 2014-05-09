class OpenProject < Project

  def type_human()
    'groups and students'
  end

  def is_group_project?
    true
  end

  def is_user_project?
    true
  end

end