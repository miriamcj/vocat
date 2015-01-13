require 'spec_helper'

describe Project do

  it 'has an error if it contains an invalid allowed_attachment_family' do
    p = FactoryGirl.build(:project, {:allowed_attachment_families => %w(rambo video)})
    expect(p.valid?).to be_falsey
    expect(p.errors[:allowed_attachment_families].size).to eq(1)
  end

  it 'allows all attachment familes to be uploaded if no attachment families are set' do
    p = FactoryGirl.build(:project, {:allowed_attachment_families => []})
    expect(p.allowed_attachment_families).to eq Project::ATTACHMENT_FAMILIES
  end

end
