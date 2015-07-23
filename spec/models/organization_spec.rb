require 'spec_helper'

describe Organization do

  it 'is does not allow subdomain to be set to "manage"' do
    org = FactoryGirl.build(:organization, name: 'org a', subdomain: 'manage')
    expect(org.errors[:subdomain].empty?).to be false
  end


end
