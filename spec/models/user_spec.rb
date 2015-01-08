require 'spec_helper'

describe 'User' do

  it 'has a valid factory' do
    expect(FactoryGirl.build(:user)).to be_valid
  end

  it 'is invalid without an email' do
    expect(FactoryGirl.build(:user, email: nil)).to_not be_valid
  end

end
