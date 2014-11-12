require 'spec_helper'

describe Asset::Vimeo do

  it 'belongs to the video family' do
    expect(Asset::Vimeo.new.family).to eq 'video'
  end

end
