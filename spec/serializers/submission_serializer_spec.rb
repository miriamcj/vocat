require 'spec_helper'

describe SubmissionSerializer do

  before(:each) do
    ApplicationController.stub(:current_user).and_return(User.first)
  end

  it 'includes an array of assets for the submission' do
    s = FactoryGirl.build(:submission)
    serializer = SubmissionSerializer.new(s, :scope => s.creator)
    h = serializer.serializable_hash
    expect(h[:assets]).to be_an_instance_of Array
  end

end
