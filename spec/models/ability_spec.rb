require 'spec_helper'
require 'cancan/matchers'


course_a = FactoryGirl.build(:course, name: 'course A')
course_b = FactoryGirl.build(:course, name: 'course B')

creator_in_a = FactoryGirl.build(:creator, email: 'creator_in_a@test.com', creator_courses: [course_a] )
creator_in_b = FactoryGirl.build(:creator, email: 'creator_in_b@test.com', creator_courses: [course_b] )
creator_in_a_and_b = FactoryGirl.build(:creator, email: 'creator_in_a_and_b@test.com', creator_courses: [course_a, course_b] )
evaluator_in_a = FactoryGirl.build(:evaluator, email: 'evaluator_in_a@test.com', evaluator_courses: [course_a] )
evaluator_in_b = FactoryGirl.build(:evaluator, email: 'evaluator_in_b@test.com', evaluator_courses: [course_b] )
evaluator_in_a_and_b = FactoryGirl.build(:evaluator, email: 'evaluator_in_a_and_b@test.com', evaluator_courses: [course_a, course_b] )
admin = FactoryGirl.build(:administrator, email: 'admin@test.com')

course_a.creators = [creator_in_a, creator_in_a_and_b]
course_b.creators = [creator_in_b, creator_in_a_and_b]
course_a.evaluators = [evaluator_in_a, evaluator_in_a_and_b]
course_b.evaluators = [evaluator_in_b, evaluator_in_a_and_b]

project_a_1 = FactoryGirl.build(:project, name: 'course A project 1', course: course_a)
project_a_2 = FactoryGirl.build(:project, name: 'course A project 2', course: course_a)
project_b_1 = FactoryGirl.build(:project, name: 'course A project 1', course: course_b)

group_a_1 = FactoryGirl.build(:group, name: 'course A group 1', course: course_a)


submission_a = FactoryGirl.build(:submission, name: 'submission for creator_a and project_a in course_a', project: project_a_1, creator: creator_in_a)
submission_b = FactoryGirl.build(:submission, name: 'submission for creator_b and project_b in course_b', project: project_b_1, creator: creator_in_b)

creator_a = Ability.new(creator_in_a)
creator_b = Ability.new(creator_in_b)
creator_ab = Ability.new(creator_in_a_and_b)
evaluator_a = Ability.new(evaluator_in_a)
evaluator_b = Ability.new(evaluator_in_b)



describe 'Ability' do

  describe 'course' do

    describe 'can be read by' do
      it 'creator that belongs to it' do
        creator_a.should be_able_to(:read, course_a)
        creator_ab.should be_able_to(:read, course_a)
      end
      it 'evaluator that does belong to it' do
        evaluator_a.should be_able_to(:read, course_a)
      end
      it 'an administrator' do
        admin.should be_able_to(:read, course_a)
      end
    end

    describe 'cannot be read by' do
      it 'creator that does not belong to it' do
        creator_a.should_not be_able_to(:read, course_b)
      end
      it 'evaluator that does not belong to it' do
        evaluator_a.should_not be_able_to(:read, course_b)
      end
    end

    describe 'can be updated by' do
      it 'evaluator that belongs to it' do
        evaluator_a.should be_able_to(:update, course_a)
      end
      it 'an administrator' do
        admin.should be_able_to(:update, course_a)
      end
    end

    describe 'cannot be updated by' do
      it 'a creator that belongs to it' do
        creator_a.should_not be_able_to(:update, course_a)
      end

      it 'a creator that does not belong to it' do
        creator_a.should_not be_able_to(:update, course_b)
      end

      it 'an evaluator that does not belong to it' do
        evaluator_b.should_not be_able_to(:update, course_a)
      end
    end

    describe 'can be evaluated by' do
      it 'evaluator that does belong to it' do
        evaluator_a.should be_able_to(:evaluate, course_a)
      end

      it 'an administrator' do
        admin.should be_able_to(:evaluate, course_a)
      end

      it 'a creator that belongs to it when peer_review is enabled' do
        course_a.settings['enable_peer_review'] = true
        creator_a.should be_able_to(:evaluate, course_a)
      end
    end

    describe 'cannot be evaluated by' do
      it 'a creator that belongs to it when peer_review is disabled' do
        course_a.settings['enable_peer_review'] = false
        creator_a.should_not be_able_to(:evaluate, course_a)
      end

      it 'evaluator that does not belong to it' do
        evaluator_a.should_not be_able_to(:evaluate, course_b)
      end
    end

  end

  describe 'project' do

    describe 'can be CRUDed by' do
      it 'an evaluator belonging to its course' do
        evaluator_a.should be_able_to(:crud, project_a_1)
      end
      it 'an administrator' do
        admin.should be_able_to(:crud, project_a_1)
      end
    end

    describe 'cannot be CRUDed by' do
      it 'an evaluator not belonging to its course' do
        evaluator_a.should_not be_able_to(:crud, project_b_1)
      end
      it 'any creator that is not also an evaluator belonging to its course' do
        creator_a.should_not be_able_to(:crud, project_a_1)
        creator_b.should_not be_able_to(:crud, project_a_1)
        creator_ab.should_not be_able_to(:crud, project_a_1)
      end
    end

    describe 'allows project submission by' do
      it 'a creator that belongs to it' do
        creator_a.should be_able_to(:submit, project_a_1)
        creator_a.should be_able_to(:submit, project_a_2)
      end
    end

    describe 'disallows project submission by' do
      it 'a creator that does not belong to it' do
        creator_a.should_not be_able_to(:submit, course_b)
      end
      it 'an evaluator that belongs to it' do
        evaluator_a.should_not be_able_to(:submit, course_a)
      end
      it 'an administrator' do
        admin.should_not be_able_to(:submit, course_a)
      end
    end

  end

  describe 'submission' do

    describe 'can be owned by' do
      it 'its creator-owner' do
        creator_a.should be_able_to(:own, submission_a)
      end
    end

    describe 'can\'t be owned by' do
      it 'a creator who does not own it' do
        creator_b.should_not be_able_to(:own, submission_a)
      end
    end

    describe 'can be evaluated by' do
      it 'an evaluator that belongs to its course' do
        evaluator_a.should be_able_to(:evaluate, submission_a)
      end
      it 'a creator that belongs to its course and is not the submission owner if peer review is enabled' do
        course_a.settings['enable_peer_review'] = true
        creator_ab.should be_able_to(:evaluate, submission_a)
      end
      it 'its owner if self evaluation is enabled' do
        course_a.settings['enable_self_evaluation'] = true
        creator_a.should be_able_to(:evaluate, submission_a)
      end
    end

    describe 'cannot be evaluated by' do
      it 'an evaluator that does not belong to its course' do
        evaluator_b.should_not be_able_to(:evaluate, submission_a)
      end
      it 'a creator that does not belong to its course' do
        course_a.settings['enable_peer_review'] = true
        creator_b.should_not be_able_to(:evaluate, submission_a)
      end
      it 'a creator that belongs to its course and is not the submission owner if peer review is not enabled' do
        course_a.settings['enable_peer_review'] = false
        creator_ab.should_not be_able_to(:evaluate, submission_a)
      end
      it 'its owner if self evaluation is not enabled' do
        course_a.settings['enable_self_evaluation'] = false
        creator_a.should_not be_able_to(:evaluate, submission_a)
      end
    end

    describe 'allows attachment by' do
      it 'an evaluator that belongs to its course' do
        evaluator_a.should be_able_to(:attach, submission_a)
      end
      it 'an administrator' do
        admin.should be_able_to(:attach, submission_a)
      end

      it 'its owner if enable creator attach is enabled' do
        course_a.settings['enable_creator_attach'] = true
        creator_a.should be_able_to(:attach, submission_a)
      end
    end

    describe 'disallows attachment by' do
      it 'an evaluator that does not belongs to its course' do
        evaluator_b.should_not be_able_to(:attach, submission_a)
      end
      it 'a creator in the same course, even if the course has peer review enabled' do
	      course_a.settings['enable_peer_review'] = true
	      creator_ab.should_not be_able_to(:attach, submission_a)
      end
      it 'its owner if enable creator attach is not enabled' do
        course_a.settings['enable_creator_attach'] = false
        creator_a.should_not be_able_to(:attach, submission_a)
      end
    end

    describe 'can be read by' do
      it 'an evaluator that belongs to its course' do
        evaluator_a.should be_able_to(:read, submission_a)
      end
      it 'its owner' do
        creator_a.should be_able_to(:read, submission_a)
      end
      it 'any course creators if peer review is enabled' do
        course_a.settings['enable_peer_review'] = true
        creator_a.should be_able_to(:read, submission_a)
        creator_ab.should be_able_to(:read, submission_a)
      end
    end

    describe 'cannot be read by' do
      it 'an evaluator that does not belong to its course' do
        evaluator_a.should_not be_able_to(:read, submission_b)
      end
      it 'any course creators if peer review is disabled' do
        course_a.settings['enable_peer_review'] = false
        creator_ab.should_not be_able_to(:read, submission_b)
      end
      it 'a creator that does not belong to its course' do
        creator_a.should_not be_able_to(:read, submission_b)
      end
      it 'an evaluator that does not belong to its course' do
        evaluator_a.should_not be_able_to(:read, submission_b)
      end
    end

    describe 'allows discussion by' do
      it 'an evaluator that belongs to its course' do
        evaluator_a.should be_able_to(:discuss, submission_a)
      end
      it 'its owner' do
        creator_a.should be_able_to(:discuss, submission_a)
      end
      it 'any course creators if public discussion is enabled' do
        course_a.settings['enable_public_discussion'] = true
        course_a.settings['enable_peer_review'] = true
        creator_a.should be_able_to(:discuss, submission_a)
        creator_ab.should be_able_to(:discuss, submission_a)
      end
    end

    describe 'disallows discussion by' do
      it 'an evaluator that does not belong to its course' do
        evaluator_b.should_not be_able_to(:discuss, submission_a)
      end
      it 'any other course creators if public discussion is disabled' do
        course_a.settings['enable_public_discussion'] = false
        course_a.settings['enable_peer_review'] = true
        creator_ab.should_not be_able_to(:discuss, submission_a)
      end
    end

  end

  describe 'group' do

    describe 'can be CRUDed by' do
      it 'an evaluator belonging to its course' do
        evaluator_a.should be_able_to(:crud, group_a_1)
      end
      it 'an administrator' do
        admin.should be_able_to(:crud, group_a_1)
      end
    end

    describe 'cannot be CRUDed by' do
      it 'an evaluator not belonging to its course' do
        evaluator_b.should_not be_able_to(:crud, group_a_1)
      end
      it 'any creator that is not also an evaluator belonging to its course' do
        creator_a.should_not be_able_to(:crud, group_a_1)
        creator_b.should_not be_able_to(:crud, group_a_1)
        creator_ab.should_not be_able_to(:crud, group_a_1)
      end
    end

    describe 'can be read by' do
      it 'any user associated with the course or an administrator' do
        creator_a.should be_able_to(:read, group_a_1)
        creator_ab.should be_able_to(:read, group_a_1)
        evaluator_a.should be_able_to(:read, group_a_1)
        admin.should be_able_to(:read, group_a_1)
      end
    end

    describe 'cannot be read by' do
      it 'any user not associated with the course' do
        creator_b.should_not be_able_to(:read, group_a_1)
        evaluator_b.should_not be_able_to(:read, group_a_1)
      end
    end

  end


end