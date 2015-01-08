require 'spec_helper'
require 'aws-sdk'

describe 'Attachment' do

  def ensure_uncommitted_file(id = 1)
    a = FactoryGirl.build(:attachment, :id => id)
    obj = @bucket.objects[a.send(:uncommitted_location)]
    if obj.exists? == false
      obj.write(Pathname.new(Rails.root.join('spec', 'data', 'test_video.mov')))
    end
  end

  def ensure_committed_file(id = 1)
    a = FactoryGirl.build(:attachment, :id => id)
    obj = @bucket.objects[a.send(:committed_location)]
    if obj.exists? == false
      obj.write(Pathname.new(Rails.root.join('spec', 'data', 'test_video.mov')))
    end
  end

  def ensure_absence_of_committed_file(id = 1)
    a = FactoryGirl.build(:attachment, :id => id)
    obj = @bucket.objects[a.send(:committed_location)]
    if obj.exists? == true
      obj.delete
    end
  end

  before(:all) do
    vocat_config = Rails.application.config.vocat
    AWS.config(:access_key_id => vocat_config[:aws][:key], :secret_access_key => vocat_config[:aws][:secret])
    @s3 = AWS::S3.new()
    @bucket = @s3.buckets[vocat_config[:aws][:s3_bucket]]
  end

  it 'has a valid factory' do
    FactoryGirl.build(:attachment).should be_valid
  end

  it 'has a factory that can be processed' do
    a = FactoryGirl.build(:attachment)
    expect(a.can_be_processed?).to be true
  end

  it 'generates a correct uncommitted source key when the ID is 1' do
    a = FactoryGirl.build(:attachment, :id => 1)
    expect(a.send(:uncommitted_location)).to eq('temporary/attachment/0_1000/0_100/1.mov')
  end

  it 'generates a correct uncommitted source key when the ID is 673801' do
    a = FactoryGirl.build(:attachment, :id => 673801)
    expect(a.send(:uncommitted_location)).to eq('temporary/attachment/673000_674000/673800_673900/673801.mov')
  end

  it 'generates a committed source key that matches the temporary key, except for the first part of the path' do
    a = FactoryGirl.build(:attachment, :id => 673801)
    expect(a.send(:committed_location)).to eq(a.send(:uncommitted_location).sub('temporary', 'source'))
  end

  it 'moves the S3 object to the committed location after its state is changed to committed' do
    a = FactoryGirl.build(:attachment, :id => 1)
    ensure_uncommitted_file(a.id)
    ensure_absence_of_committed_file(a.id)
    a.commit
    expect(@bucket.objects[a.location].exists?).to be true
  end

  it 'reports that it can be processed' do
    a = FactoryGirl.build(:attachment, :id => 1, :state => 'committed')
    expect(a.can_be_processed?).to be true
  end

  it 'destroys its s3 object when it is destroyed and it has been committed' do
    ensure_committed_file(1)
    a = FactoryGirl.create(:attachment, :id => 1, :state => 'committed')
    location = a.location
    expect(@bucket.objects[location].exists?).to be true
    a.destroy
    expect(@bucket.objects[location].exists?).to be false
  end

  it 'destroys its s3 object when it is destroyed and it is uncommitted' do
    ensure_uncommitted_file(1)
    a = FactoryGirl.create(:attachment, :id => 1, :state => 'uncommitted')
    location = a.location
    expect(@bucket.objects[location].exists?).to be true
    a.destroy
    expect(@bucket.objects[location].exists?).to be false
  end


  it 'destroys its variants when it is destroyed' do
    ensure_committed_file(1)
    a = FactoryGirl.create(:attachment, :id => 1, :state => 'committed')
    available_count = a.available_processors.length
    a.start_processing
    variant_ids = a.variants.pluck :id
    a.destroy
    expect(available_count).to be > 0
    expect(Attachment::Variant.where(:id => variant_ids).count).to eq 0
  end






end
