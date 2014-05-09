class OpenProject < Project

  def type_human()
    'groups and students'
  end

  def accepts_group_submissions?
    true
  end

  def accepts_user_submissions?
    true
  end

end