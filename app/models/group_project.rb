class GroupProject < Project

  def type_human()
    'groups'
  end

  def accepts_group_submissions?
    true
  end

  def accepts_user_submissions?
    false
  end

end