require 'spec_helper'

describe Statistics do
  describe '.admin_stats' do
    it 'returns an array' do
      expect(Statistics::admin_stats(FactoryGirl.create(:organization))).to be_a Array
    end

  end


end