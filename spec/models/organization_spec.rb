require 'spec_helper'

describe Organization do
  let(:invalid_attributes) {
    org = FactoryGirl.build(:organization)
    org.subdomain = 'manage'
    org.attributes
  }

  it 'is does not allow subdomain to be set to "manage"' do
    organization = Organization.create(invalid_attributes)
    expect(organization.errors[:subdomain].empty?).to be false
  end


end
