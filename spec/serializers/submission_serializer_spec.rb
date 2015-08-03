# == Schema Information
#
# Table name: submissions
#
#  id                     :integer          not null, primary key
#  name                   :string
#  summary                :text
#  project_id             :integer
#  creator_id             :integer
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  published              :boolean
#  discussion_posts_count :integer          default(0)
#  creator_type           :string           default("User")
#  assets_count           :integer          default(0)
#
# Indexes
#
#  index_submissions_on_creator_id  (creator_id)
#  index_submissions_on_project_id  (project_id)
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
