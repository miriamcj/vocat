require 'spec_helper'

describe Attachment::Inspector do

  it 'returns the correct type for an extension' do
    expect(Attachment::Inspector.extensionToType('mov')).to eq(:video)
  end

  it 'returns the correct type for an attachment' do
    attachment = FactoryGirl.build(:attachment, media_file_name: 'group1.mov')
    expect(Attachment::Inspector.attachmentToType(attachment)).to eq(:video)
  end



end
