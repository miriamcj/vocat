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

  def to_s
    name
  end

  protected

  def downcase_subdomain
    self.subdomain.downcase! if attribute_present?("subdomain")
  end

end
