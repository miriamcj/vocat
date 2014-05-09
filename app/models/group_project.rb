class GroupProject < Project

  def type_human()
    'groups'
  end

  def is_group_project?
    true
  end

  def is_user_project?
    false
  end

end