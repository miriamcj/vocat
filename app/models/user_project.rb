class UserProject < Project

  def type_human()
    'students'
  end

  def is_group_project?
    false
  end

  def is_user_project?
    true
  end



end