class MoveSettingsToOrganizations < ActiveRecord::Migration
  def change
    add_column :organizations, :ldap_enabled, :boolean, :default => false
    add_column :organizations, :ldap_host, :string
    add_column :organizations, :ldap_encryption, :string, :default => 'simple_tls'
    add_column :organizations, :ldap_port, :integer, :default => 3269
    add_column :organizations, :ldap_filter_dn, :string
    add_column :organizations, :ldap_filter, :string, :default => '(mail={email})'
    add_column :organizations, :ldap_bind_dn, :string
    add_column :organizations, :ldap_bind_cn, :string
    add_column :organizations, :ldap_bind_password, :string
    add_column :organizations, :ldap_org_identity, :string, :default => 'name'
    add_column :organizations, :ldap_reset_pw_url, :string
    add_column :organizations, :ldap_recover_pw_url, :string
    add_column :organizations, :ldap_message, :text
    add_column :organizations, :ldap_evaluator_email_domain, :string
    add_column :organizations, :ldap_default_role, :string, :default => 'creator'
    add_column :organizations, :email_default_from, :string
    add_column :organizations, :email_notification_course_request, :string
  end
end
