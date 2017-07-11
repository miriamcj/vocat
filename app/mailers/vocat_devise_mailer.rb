class VocatDeviseMailer < Devise::Mailer
  helper :application # gives access to all helpers defined within `application_helper`.
  include Devise::Controllers::UrlHelpers # Optional. eg. `confirmation_url`
  default template_path: 'devise/mailer' # to make sure that your mailer uses the devise views


  def confirmation_instructions(record, token, opts={})
    @organization = record.organization
    @host = record.is_superadministrator? ? VocatSettings.management_domain : @organization.domain
    super
  end

  def reset_password_instructions(record, token, opts={})
    @organization = record.organization
    @host = record.is_superadministrator? ? VocatSettings.management_domain : @organization.domain
    super
  end

  def unlock_instructions(record, token, opts={})
    @organization = record.organization
    @host = record.is_superadministrator? ? VocatSettings.management_domain : @organization.domain
    super
  end


end
