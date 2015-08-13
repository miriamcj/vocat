# == Schema Information
#
# Table name: organizations
#
#  id                                :integer          not null, primary key
#  name                              :string
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
  validates_presence_of :subdomain, :email_default_from, :name
  validates_format_of :subdomain, :with => /[A-Za-z0-9-]+/, :message => 'The subdomain can only contain alphanumeric characters and dashes.', :allow_blank => true
  validates_uniqueness_of :subdomain, :case_sensitive => false
  validates :subdomain, exclusion: { in: %w(manage), message: "Subdomain %{value} is reserved." }
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

  def self.count_by_subdomain(subdomain)
    Organization.where(:active => true, :subdomain => subdomain).count
  end


  def recent_grouped_sorted_courses(limit = nil)
    courses.where('courses.year >= ?', Time.now.year).sorted.limit(limit).group_by do |course|
      "#{course.semester} #{course.year}"
    end
  end

  def usage
    usages = []
    11.downto(0) do |i|
      month = i.months.ago.month
      year = i.months.ago.year
      uploaded = Attachment.in_organization(self).created_in_month(month, year).sum(:media_file_size)
      processed = Attachment::Variant.in_organization(self).created_in_month(month, year).sum(:file_size)
      stored_to_date = Attachment.in_organization(self).created_before(month, year).sum(:media_file_size) + Attachment::Variant.in_organization(self).created_before(month, year).sum(:file_size)
      stored_this_month = uploaded + processed
      minutes = Attachment::Variant.in_organization(self).created_in_month(month, year).sum(:duration)
      usages.push({:month => month, :year => year, :uploaded => uploaded, :processed => processed, :stored_this_month => stored_this_month, :stored_to_date => stored_to_date, :minutes => minutes})
    end
    usages.reverse
  end

  protected

  def downcase_subdomain
    self.subdomain.downcase! if attribute_present?("subdomain")
  end


end
