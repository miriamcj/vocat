class UserProject < Project

  def type_human()
    'students'
  end

  def accepts_group_submissions?
    false
  end

  def accepts_user_submissions?
    true
  end

end