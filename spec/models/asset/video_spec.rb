require 'spec_helper'

describe Asset::Video do

  it 'belongs to the video family' do
    expect(Asset::Video.new.family).to eq 'video'
  end

end
