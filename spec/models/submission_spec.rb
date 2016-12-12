require 'spec_helper'

describe 'Submission' do

  it 'has a valid factory' do
    expect(FactoryGirl.build(:submission)).to be_valid
  end

  it 'returns the first sorted asset thumbnail' do
    s = FactoryGirl.create(:submission)
    s.assets << FactoryGirl.create(:asset, :submission => s, :listing_order => 1000)
    s.assets << FactoryGirl.create(:asset, :submission => s, :listing_order => 0)
    expect(s.first_asset.thumbnail).to eq(s.thumb)
  end


  context "when getting visible evaluations for a submission" do
    before (:each) {
      @submission = FactoryGirl.create(:submission)
      @e1 = FactoryGirl.create(:evaluator)
      @e2 = FactoryGirl.create(:evaluator)
      course = @submission.project.course
      course.enroll(@e1, 'evaluator')
      course.enroll(@e2, 'evaluator')
      @r = FactoryGirl.create(:rubric)
      @eval_unpublished = FactoryGirl.create(:evaluation, :published => false, evaluator: @e1, submission: @submission, rubric: @r)
      @eval_published = FactoryGirl.create(:evaluation, :published => false, evaluator: @e2, submission: @submission, rubric: @r)
    }

    it 'an unpublished evaluator evaluation is visible to an evaluator who did not author the evaluation' do
      expect(@submission.evaluations_visible_to(@e2).include?(@eval_unpublished)).to be true
    end

    it 'an unpublished evaluator evaluation is visible to the evaluator who authored the evaluation' do
      expect(@submission.evaluations_visible_to(@e1).include?(@eval_unpublished)).to be true
    end
  end

  context "when being reassigned" do

    before (:each) {
      @course = FactoryGirl.create(:course)
      @project = FactoryGirl.create(:user_project, course: @course)
      @c1 = FactoryGirl.create(:creator)
      @c2 = FactoryGirl.create(:creator)
      @course.enroll(@c1, 'creator')
      @course.enroll(@c2, 'creator')
      @factory = SubmissionFactory.new
      @s1 = @factory.one_by_creator_and_project(@c1, @project)
      @s2 = @factory.one_by_creator_and_project(@c2, @project)
    }

    it 'starts with the correct user' do
      expect(@s1.creator).to eq @c1
    end

    it 'can be reassigned from one user to another' do
      @s1.reassign_to!(@c2)
      expect(@s1.creator).to be @c2
    end

    it 'can be reassigned from one user to another and back again' do
      @s1.reassign_to!(@c2)
      @s1.reassign_to!(@c1)
      expect(@s1.creator).to be @c1
    end

    it 'can result in exchanged submissions' do
      @s1.reassign_to!(@c2)
      expect(@factory.one_by_creator_and_project(@c1, @project).id).to be @s2.id
    end

    it 'can result in replaced submissions' do
      s2_id = @s2.id
      @s1.reassign_to!(@c2, 'replace')
      expect {
        Submission.find s2_id
      }.to raise_error(ActiveRecord::RecordNotFound)
    end

  end

end
