require 'spec_helper'

describe Asset::Image do

  it 'belongs to the image family' do
    expect(Asset::Image.new.family).to eq :image
  end

end
