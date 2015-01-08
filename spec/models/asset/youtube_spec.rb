require 'spec_helper'

describe Asset::Youtube do

  it 'belongs to the video family' do
    expect(Asset::Youtube.new.family).to eq :video
  end

end
