require 'spec_helper'

describe 'User' do

  it 'has a valid factory' do
    FactoryGirl.build(:user).should be_valid
  end

  it 'is invalid without an email' do
    FactoryGirl.build(:user, email: nil).should_not be_valid
  end

end
