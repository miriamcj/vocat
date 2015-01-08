require 'spec_helper'

describe 'Submission' do

  it 'has a valid factory' do
    expect(FactoryGirl.build(:submission)).to be_valid
  end

  context "when getting visible evaluations for a submission" do
    before (:all) {
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

end
