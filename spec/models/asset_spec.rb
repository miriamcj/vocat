require 'spec_helper'

describe Asset do

  it 'fails validation without a type' do
    expect(Asset.new).to have(1).error_on(:type)
  end

  it 'has an active model serializer' do
    expect(Asset.active_model_serializer.new(Asset.new)).to be_kind_of ActiveModel::Serializer
  end

end
