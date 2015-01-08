require 'spec_helper'

describe Asset::Audio do

  it 'belongs to the audio family' do
    expect(Asset::Audio.new.family).to eq :audio
  end

end
