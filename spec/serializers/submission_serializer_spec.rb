# == Schema Information
#
# Table name: submissions
#
#  id                     :integer          not null, primary key
#  name                   :string(255)
#  summary                :text
#  project_id             :integer
#  creator_id             :integer
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  published              :boolean
#  discussion_posts_count :integer          default(0)
#  creator_type           :string(255)      default("User")
#  assets_count           :integer          default(0)
#

require 'spec_helper'

describe SubmissionSerializer do

  before(:each) do
    ApplicationController.stub(:current_user).and_return(User.first)
  end

  it 'includes an array of assets for the submission' do
    s = FactoryGirl.build(:submission)
    serializer = SubmissionSerializer.new(s, :scope => s.creator)
    h = serializer.serializable_hash
    expect(h[:assets]).to be_an_instance_of Array
  end

end
