# == Schema Information
#
# Table name: organizations
#
#  id                                :integer          not null, primary key
#  name                              :string(255)
#  created_at                        :datetime         not null
#  updated_at                        :datetime         not null
#  subdomain                         :string
#  active                            :boolean
#  logo                              :string
#  ldap_enabled                      :boolean          default(FALSE)
#  ldap_host                         :string
#  ldap_encryption                   :string           default("simple_tls")
#  ldap_port                         :integer          default(3269)
#  ldap_filter_dn                    :string
#  ldap_filter                       :string           default("(mail={email})")
#  ldap_bind_dn                      :string
#  ldap_bind_cn                      :string
#  ldap_bind_password                :string
#  ldap_org_identity                 :string           default("name")
#  ldap_reset_pw_url                 :string
#  ldap_recover_pw_url               :string
#  ldap_message                      :text
#  ldap_evaluator_email_domain       :string
#  ldap_default_role                 :string           default("creator")
#  email_default_from                :string
#  email_notification_course_request :string
#

class Organization < ActiveRecord::Base
  validates_presence_of :subdomain
  validates_format_of :subdomain, :with => /[A-Za-z0-9-]+/, :message => 'The subdomain can only contain alphanumeric characters and dashes.', :allow_blank => true
  validates_uniqueness_of :subdomain, :case_sensitive => false
  before_validation :downcase_subdomain
  has_many :courses
  has_many :users
  has_many :rubrics
  has_many :course_requests

  def to_s
    name
  end

  def url
    if Rails.application.config.vocat.enforce_ssl
      "https://#{domain}"
    else
      "http://#{domain}"
    end
  end

  def domain
    [subdomain, Rails.application.config.vocat.domain].join('.')
  end

  def self.find_one_by_subdomain(subdomain)
    Organization.where(:active => true, :subdomain => subdomain).first
  end

  def recent_grouped_sorted_courses(limit = nil)
    courses.where('courses.year >= ?', Time.now.year).sorted.limit(limit).group_by do |course|
      "#{course.semester} #{course.year}"
    end
  end

  protected

  def downcase_subdomain
    self.subdomain.downcase! if attribute_present?("subdomain")
  end


end
