require 'spec_helper'

describe Asset do

  it 'is valid without a type, because it will automatically be assigned one' do
    a = Asset.create
    expect(a.valid?).to be true
    expect(a.errors[:type].size).to eq(0)
  end

  it 'has an active model serializer' do
    expect(Asset.active_model_serializer.new(Asset.new)).to be_kind_of ActiveModel::Serializer
  end

  it 'has a valid factory' do
    expect(FactoryGirl.build(:asset)).to be_valid
  end

  it 'can be saved without a submission' do
    expect(FactoryGirl.create(:asset, {submission: nil})).to be_valid
  end

  it 'commits an attachment when it is attached' do
    user = FactoryGirl.create(:user)
    attachment = FactoryGirl.create(:attachment, {user: user})
    allow(attachment).to receive(:commit)
    asset = FactoryGirl.create(:asset, {author: user})
    asset.attach(attachment)
    expect(attachment).to have_received(:commit)
  end

  it 'refuses to attach an attachment owned by another user' do
    user_a = FactoryGirl.create(:user)
    user_b = FactoryGirl.create(:user)
    attachment = FactoryGirl.create(:attachment, {user: user_a})
    asset = FactoryGirl.create(:asset, {author: user_b})
    expect{ asset.attach(attachment) }.to raise_error(CanCan::AccessDenied)
  end

end
