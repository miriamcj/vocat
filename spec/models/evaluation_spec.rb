require 'spec_helper'

describe 'Evaluation' do

  it 'has a valid factory' do
    expect(FactoryGirl.build(:evaluation)).to be_valid
  end

  it 'returns score_ranges in the correct format' do
    e = FactoryGirl.build(:evaluation)
    expect(e.score_ranges.length).to eq(e.rubric.field_keys.length)
    expect(e.score_ranges.keys).to eq(e.rubric.field_keys)
    e.score_ranges.each do |key, value|
      expect(value.keys).to eq([:low, :high])
    end
  end

end
