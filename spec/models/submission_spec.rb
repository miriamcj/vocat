require 'spec_helper'

describe 'Submission' do

  it 'has a valid factory' do
    FactoryGirl.build(:submission).should be_valid
  end

  context "when getting visible evaluations for a submission" do
    before (:all) {
      @submission = FactoryGirl.create(:submission)
      @e1 = FactoryGirl.create(:evaluator)
      @e2 = FactoryGirl.create(:evaluator)
      @submission.project.course.evaluators << @e1
      @submission.project.course.evaluators << @e2
      @r = FactoryGirl.create(:rubric)
      @eval_unpublished = FactoryGirl.create(:evaluation, :published => false, evaluator: @e1, rubric: @r)
      @eval_published = FactoryGirl.create(:evaluation, :published => false, evaluator: @e2, rubric: @r)
      @submission.evaluations << @eval_unpublished
      @submission.evaluations << @eval_published
    }

    it 'an unpublished evaluator evaluation is not visible to an evaluator who did not author the evaluation' do
      expect(@submission.evaluations_visible_to(@e2).include?(@eval_unpublished)).to be_false
    end

    it 'an unpublished evaluator evaluation is visible to the evaluator who authored the evaluation' do
      expect(@submission.evaluations_visible_to(@e1).include?(@eval_unpublished)).to be_true
    end
  end

end
