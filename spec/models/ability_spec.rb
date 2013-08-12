require 'spec_helper'
require 'cancan/matchers'

describe 'User' do

  other_creator = FactoryGirl.build(:creator)
  other_evaluator = FactoryGirl.build(:evaluator)
  creator = FactoryGirl.build(:creator)
  evaluator = FactoryGirl.build(:evaluator)
  administrator = FactoryGirl.build(:administrator)

  course = FactoryGirl.build(:course)
  other_course = FactoryGirl.build(:course)
  course_project = FactoryGirl.build(:project, course: course)


  other_project = FactoryGirl.build(:project, course: other_course)
  peer_review_course = FactoryGirl.build(:course, settings: {'enable_peer_review' => true})

  course.creators << creator
  course.evaluators << evaluator
  peer_review_course.creators << creator
  peer_review_course.evaluators << evaluator

  owned_submission = FactoryGirl.build(:submission, project: course_project, creator: creator)
  other_submission = FactoryGirl.build(:submission, project: other_project, creator: other_creator)


  describe 'abilities' do

    subject { ability }
    let(:ability) { Ability.new(user) }
    let(:user) { nil }

    context "when is a course creator" do
      let(:user) { creator }

      # Course Abilities
      it { should be_able_to(:read, course) }
      it { should_not be_able_to(:update, course) }
      it { should_not be_able_to(:evaluate, course) }
      it { should be_able_to(:evaluate, peer_review_course) }

			# Project Abilities
      it { should_not be_able_to(:manage, course_project) }
      it { should_not be_able_to(:manage, other_project) }
      it { should be_able_to(:submit, course_project)}
      it { should_not be_able_to(:submit, other_project)}

	    # Submission Abilities
	    it { should be_able_to :own, owned_submission }
      it { should_not be_able_to :own, other_submission }

    end

    context "when is a course evaluator" do
      let(:user) { evaluator }

			# Course Abilities
      it { should be_able_to(:read, course) }
      it { should be_able_to(:update, course) }
      it { should be_able_to(:evaluate, course) }
      it { should be_able_to(:evaluate, peer_review_course) }

			# Project Abilities
      it { should be_able_to(:create, course_project) }
      it { should be_able_to(:read, course_project) }
      it { should be_able_to(:update, course_project) }
      it { should be_able_to(:delete, course_project) }
      it { should_not be_able_to(:create, other_project) }
      it { should_not be_able_to(:read, other_project) }
      it { should_not be_able_to(:update, other_project) }
      it { should_not be_able_to(:delete, other_project) }
      it { should_not be_able_to(:submit, course_project)}
      it { should_not be_able_to(:submit, other_project)}

    end

    context "when is a administrator" do
      let(:user) { administrator }

			# Course Abilities
      it { should be_able_to(:read, course) }
      it { should be_able_to(:update, course) }
      it { should be_able_to(:update, other_course) }
      it { should be_able_to(:evaluate, course) }
      it { should be_able_to(:evaluate, peer_review_course) }

			# Project Abilities
      it { should be_able_to(:create, course_project) }
      it { should be_able_to(:read, course_project) }
      it { should be_able_to(:update, course_project) }
      it { should be_able_to(:delete, course_project) }
      it { should be_able_to(:create, other_project) }
      it { should be_able_to(:read, other_project) }
      it { should be_able_to(:update, other_project) }
      it { should be_able_to(:delete, other_project) }
      it { should_not be_able_to(:submit, course_project)}
      it { should_not be_able_to(:submit, other_project)}
    end

    context "when is an other creator" do
      let(:user) { other_creator }

      # Course Abilities
      it { should_not be_able_to(:read, course) }
      it { should_not be_able_to(:update, course) }
      it { should_not be_able_to(:evaluate, course) }
      it { should_not be_able_to(:evaluate, peer_review_course) }

      # Project Abilities
      it { should_not be_able_to(:create, course_project) }
      it { should_not be_able_to(:read, course_project) }
      it { should_not be_able_to(:update, course_project) }
      it { should_not be_able_to(:delete, course_project) }
      it { should_not be_able_to(:create, other_project) }
      it { should_not be_able_to(:read, other_project) }
      it { should_not be_able_to(:update, other_project) }
      it { should_not be_able_to(:delete, other_project) }
      it { should_not be_able_to(:submit, course_project)}
      it { should_not be_able_to(:submit, other_project)}
    end

    context "when is an other evaluator" do
      let(:user) { other_evaluator }

      # Course Abilities
      it { should_not be_able_to(:read, course) }
      it { should_not be_able_to(:update, course) }
      it { should_not be_able_to(:evaluate, course) }
      it { should_not be_able_to(:evaluate, peer_review_course) }

			# Project Abilities
      it { should_not be_able_to(:create, course_project) }
      it { should_not be_able_to(:read, course_project) }
      it { should_not be_able_to(:update, course_project) }
      it { should_not be_able_to(:delete, course_project) }
      it { should_not be_able_to(:create, other_project) }
      it { should_not be_able_to(:read, other_project) }
      it { should_not be_able_to(:update, other_project) }
      it { should_not be_able_to(:delete, other_project) }
      it { should_not be_able_to(:submit, course_project)}
      it { should_not be_able_to(:submit, other_project)}

    end


  end
end