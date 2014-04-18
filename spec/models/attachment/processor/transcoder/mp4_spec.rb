require 'spec_helper'

describe Attachment::Processor::Transcoder::Mp4 do

  def ensure_committed_file(id = 1)
    a = FactoryGirl.build(:attachment, :id => id)
    obj = @bucket.objects[a.send(:committed_s3_source_key)]
    if obj.exists? == false
      obj.write(Pathname.new(Rails.root.join('spec', 'data', 'test_video.mov')))
    end
  end

  before(:all) do
    vocat_config = YAML.load_file(Rails.root.join('config', 'environment.yml'))[Rails.env.to_sym]
    AWS.config(:access_key_id => vocat_config[:aws][:key], :secret_access_key => vocat_config[:aws][:secret])
    @s3 = AWS::S3.new()
    @bucket = @s3.buckets[vocat_config[:aws][:s3_bucket]]
    @mp4 = Attachment::Processor::Transcoder::Mp4.new
  end

  it 'can be instantiated' do
    expect(@mp4).to be_instance_of(Attachment::Processor::Transcoder::Mp4)
  end

  it 'can process an attachment with a file type that is included among its handled_formats attribute' do
    a = FactoryGirl.build(:attachment, :id => 1)
    expect(@mp4.can_process? a).to be_true
  end

  it 'cannot process an attachment with a file type that is not included among its handled_formats attribute' do
    a = FactoryGirl.build(:attachment, :id => 1, :media_file_name => 'file.txt')
    expect(@mp4.can_process? a).to be_false
  end

  it 'does not detect an existing variant when no existing variant exists' do
    a = FactoryGirl.build(:attachment, :id => 1)
    expect(@mp4.existing_variant?(a)).to be_false
  end

  it 'detects an existing variant when an existing variant exists' do
    a = FactoryGirl.create(:attachment, :id => 1)
    v = FactoryGirl.create(:attachment_variant, :format => 'mp4', :attachment => a, :processor_name => 'Attachment::Processor::Transcoder::Mp4')
    expect(@mp4.existing_variant?(a)).to be_true
  end


end
