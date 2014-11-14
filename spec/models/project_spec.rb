require 'spec_helper'

describe Project do

  it 'has an error if it contains an invalid allowed_attachment_family' do
    p = FactoryGirl.build(:project, {:allowed_attachment_families => 'rambo,image'})
    expect(p).to have(1).error_on(:allowed_attachment_families)
  end

end
