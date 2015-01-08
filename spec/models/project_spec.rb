require 'spec_helper'

describe Project do

  it 'has an error if it contains an invalid allowed_attachment_family' do
    p = FactoryGirl.build(:project, {:allowed_attachment_families => %w(rambo video)})
    expect(p.valid?).to be_falsey
    expect(p.errors[:allowed_attachment_families].size).to eq(1)
  end

end
