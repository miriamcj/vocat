# == Schema Information
#
# Table name: organizations
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  subdomain  :string
#  active     :boolean
#  logo       :string
#

class Organization < ActiveRecord::Base
  validates_presence_of :subdomain
  validates_format_of :subdomain, :with => /[A-Za-z0-9-]+/, :message => 'The subdomain can only contain alphanumeric characters and dashes.', :allow_blank => true
  validates_uniqueness_of :subdomain, :case_sensitive => false
  before_validation :downcase_subdomain
  has_many :courses
  has_many :users

  def to_s
    name
  end

  def domain
    [subdomain, Rails.application.config.vocat.domain].join('.')
  end

  def self.find_one_by_subdomain(subdomain)
    Organization.where(:active => true, :subdomain => subdomain).first
  end

  protected

  def downcase_subdomain
    self.subdomain.downcase! if attribute_present?("subdomain")
  end


end
