class UserMailer < ActionMailer::Base
  default from: Rails.application.config.vocat.email.default_from

  def welcome_email(user)
    @user = user

    # Generate a reset password token
    raw, enc = Devise.token_generator.generate(@user.class, :reset_password_token)
    @user.reset_password_token   = enc
    @user.reset_password_sent_at = Time.now.utc
    @user.save(:validate => false)
    @support_email = Rails.application.config.vocat.email.notification.support_email
    @token = raw

    mail(to: @user.email, subject: 'Welcome to Vocat')
  end

end
