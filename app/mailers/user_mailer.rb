class UserMailer < ActionMailer::Base

  def welcome_email(user)
    @user = user

    # Generate a reset password token
    raw, enc = Devise.token_generator.generate(@user.class, :reset_password_token)
    @user.reset_password_token = enc
    @user.reset_password_sent_at = Time.now.utc
    @user.save(:validate => false)
    @organization = @user.organization
    @support_email = Rails.application.config.vocat.email.notification.support_email
    @token = raw
    @host = Rails.application.config.vocat.email.url_domain
    mail(to: @user.email, from: from(@organization), subject: 'Welcome to Vocat')
  end

  protected

  def from(organization)
    organization.email_default_from || Rails.application.config.vocat.email.default_from
  end

end
