class UserMailerPreview < ActionMailer::Preview

  def new_user
    user = User.first
    UserMailer.welcome_email(user)
  end

end