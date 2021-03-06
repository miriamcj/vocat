require 'spec_helper'
require 'cancan/matchers'


RSpec::Matchers.define :have_ability do |ability_hash, options = {}|

  match do |user|
    ability         = Ability.new(user)
    target          = options[:for]
    @ability_result = {}
    ability_hash    = {ability_hash => true} if ability_hash.is_a? Symbol # e.g.: :create => {:create => true}
    ability_hash    = ability_hash.inject({}){|_, i| _.merge({i=>true}) } if ability_hash.is_a? Array # e.g.: [:create, :read] => {:create=>true, :read=>true}
    ability_hash.each do |action, true_or_false|
      @ability_result[action] = ability.can?(action, target)
    end
    ability_hash == @ability_result
  end

  failure_message do |user|
    ability_hash,options = expected
    ability_hash         = {ability_hash => true} if ability_hash.is_a? Symbol # e.g.: :create
    ability_hash         = ability_hash.inject({}){|_, i| _.merge({i=>true}) } if ability_hash.is_a? Array # e.g.: [:create, :read] => {:create=>true, :read=>true}
    target               = options[:for]
    message              = "expected User:#{user} to have ability:#{ability_hash} for #{target}, but actual result is #{@ability_result}"
  end

  description do
    target = expected.last[:for]
    target = if target.class == Symbol
               target.to_s.capitalize
             elsif target.class == Class || target.class == Module
               target.to_s.capitalize
             else
               target.class.name
             end
    authorized_abilities = ability_hash.select{|key, val| val == true}
    authorized_string = "authorized to #{authorized_abilities.keys.join(", ")}"
    unauthorized_abilities = ability_hash.select{|key, val| val == false}
    unauthorized_string = "unauthorized to #{unauthorized_abilities.keys.join(", ")}"
    "be #{authorized_string unless authorized_abilities.empty?}" \
      "#{' and ' unless authorized_abilities.empty? || unauthorized_abilities.empty?}" \
      "#{unauthorized_string unless unauthorized_abilities.empty?}" \
      " the #{target}"
  end
end

describe "Abilities" do

  before(:each) do

    @org_a = FactoryGirl.create(:organization, name: 'org a')
    @org_b = FactoryGirl.create(:organization, name: 'org a')

    @course_a = FactoryGirl.create(:course, name: 'course A', organization: @org_a)
    @course_b = FactoryGirl.create(:course, name: 'course B', organization: @org_a)
    @course_other_org = FactoryGirl.create(:course, name: 'course B', organization: @org_b)


    @creator_in_course_a = FactoryGirl.build(:creator, email: 'creator_in_a@test.com', organization: @org_a)
    @another_creator_in_course_a = FactoryGirl.build(:creator, email: 'another_creator_in_course_a@test.com', organization: @org_a)
    @creator_in_course_b = FactoryGirl.build(:creator, email: 'creator_in_b@test.com', organization: @org_a)
    @another_creator_in_course_b = FactoryGirl.build(:creator, email: 'another_creator_in_course_b@test.com', organization: @org_a)
    @creator_in_course_a_and_b = FactoryGirl.build(:creator, email: 'creator_in_a_and_b@test.com', organization: @org_a )

    @evaluator_in_course_a = FactoryGirl.build(:evaluator, email: 'evaluator_in_a@test.com', organization: @org_a)
    @evaluator_in_course_b = FactoryGirl.build(:evaluator, email: 'evaluator_in_b@test.com', organization: @org_a)
    @evaluator_in_course_a_and_b = FactoryGirl.build(:evaluator, email: 'evaluator_in_a_and_b@test.com', organization: @org_a)

    @creator_in_course_other_org = FactoryGirl.build(:creator, email: 'creator_in_a@test.com', organization: @org_b)
    @another_creator_in_course_other_org = FactoryGirl.build(:creator, email: 'another_creator_in_course_a@test.com', organization: @org_b)
    @evaluator_in_course_other_org = FactoryGirl.build(:evaluator, email: 'evaluator_in_a@test.com', organization: @org_b)

    @admin = FactoryGirl.build(:administrator, email: 'admintest.com', organization: @org_a)
    @admin_other_org = FactoryGirl.build(:administrator, email: 'admintestotherorg.com', organization: @org_b)

    @course_a.enroll(@creator_in_course_a, 'creator')
    @course_a.enroll(@another_creator_in_course_a, 'creator')
    @course_a.enroll(@creator_in_course_a_and_b, 'creator')
    @course_a.enroll(@evaluator_in_course_a, 'evaluator')
    @course_a.enroll(@evaluator_in_course_a_and_b, 'evaluator')

    @course_b.enroll(@creator_in_course_b, 'creator')
    @course_b.enroll(@another_creator_in_course_b, 'creator')
    @course_b.enroll(@creator_in_course_a_and_b, 'creator')
    @course_b.enroll(@evaluator_in_course_b, 'evaluator')
    @course_b.enroll(@evaluator_in_course_a_and_b, 'evaluator')

    @course_other_org.enroll(@creator_in_course_other_org, 'creator')
    @course_other_org.enroll(@another_creator_in_course_other_org, 'creator')
    @course_other_org.enroll(@evaluator_in_course_other_org, 'evaluator')

    @first_project_in_course_a = FactoryGirl.build(:project, name: 'course A project 1', course: @course_a)
    @second_project_in_course_a = FactoryGirl.build(:project, name: 'course A project 2', course: @course_a)
    @first_project_in_course_b = FactoryGirl.build(:project, name: 'course A project 1', course: @course_b)
    @first_project_in_course_other_org = FactoryGirl.build(:project, name: 'course A project 1', course: @course_other_org)
    @second_project_in_course_other_org = FactoryGirl.build(:project, name: 'course A project 2', course: @course_other_org)

    @first_group_in_course_a = FactoryGirl.build(:group, name: 'course A group 1', course: @course_a)
    @first_group_in_course_a.creators << @creator_in_course_a

    @submission_for_first_project_in_course_a = FactoryGirl.build(:submission, name: 'submission for creator_a and project_a in course_a', project: @first_project_in_course_a, creator: @creator_in_course_a)
    @submission_for_first_project_in_course_b = FactoryGirl.build(:submission, name: 'submission for creator_b and project_b in course_b', project: @first_project_in_course_b, creator: @creator_in_course_b)
    @submission_for_first_project_in_course_other_org = FactoryGirl.build(:submission, name: 'submission for creator_other_org in course_other_org', project: @first_project_in_course_other_org, creator: @creator_in_course_other_org)

    @group_submission_for_first_project_in_course_a = FactoryGirl.build(:group_submission, name: 'submission for first_group_in_course_a and project_a', project: @first_project_in_course_a, creator: @first_group_in_course_a)

    @ability_aliases = {
        :read_only => {
            :index => true,
            :show => true,
            :edit => false,
            :new => false,
            :create => false,
            :update => false,
            :destroy => false,
        },
        :read_create_only => {
            :index => true,
            :show => true,
            :edit => false,
            :new => true,
            :create => true,
            :update => false,
            :destroy => false,
        },
        :show_only => {
            :index => false,
            :show => true,
            :edit => false,
            :new => false,
            :create => false,
            :update => false,
            :destroy => false,
        },
        :read_write => {
            :index => true,
            :show => true,
            :edit => true,
            :new => true,
            :create => true,
            :update => true,
            :destroy => false,
        },
        :read_write_destroy => {
            :index => true,
            :show => true,
            :edit => true,
            :new => true,
            :create => true,
            :update => true,
            :destroy => true,
        },
        :forbidden => {
            :index => false,
            :show => false,
            :edit => false,
            :new => false,
            :create => false,
            :update => false,
            :destroy => false,
        }
    }
  end

  context "for Users" do
    let ( :target_user ) { @creator_in_course_a}
    context "when the current_user is an admin, she" do
      let ( :user ) { @admin }
      it { expect(user).to have_ability(@ability_aliases[:read_write_destroy], for: target_user) }
    end
    context "when the current_user is an admin in another org, she" do
      let ( :user ) { @admin_other_org }
      it { expect(user).to have_ability(@ability_aliases[:forbidden], for: target_user) }
    end
    context "when the current_user is an evaluator for a course the user is enrolled in, she" do
      let ( :user ) { @evaluator_in_course_a }
      it { expect(user).to have_ability({:index=>true, :show=>true, :edit=>false, :new=>false, :create=>false, :update=>false, :destroy=>false}, for: target_user) }
    end
    context "when the current_user is an evaluator" do
      let ( :user ) { @evaluator_in_course_a }
      it { expect(user).to have_ability(:search, for: @creator_in_course_b) }
     it { expect(user).to have_ability(@ability_aliases[:forbidden], for: @creator_in_course_other_org) }
    end
    context "when the current_user is a creator" do
      let ( :user ) { @creator_in_course_a}
      it { expect(user).to_not have_ability(:search, for: @creator_in_course_b) }
    end
    context "when the current_user is the same user, she" do
      let ( :user ) { @creator_in_course_a }
      it { expect(user).to have_ability(@ability_aliases[:read_write], for: target_user) }
    end
    context "when the current_user is a different user, she" do
      let ( :user ) { @creator_in_course_b }
      it { expect(user).to have_ability(@ability_aliases[:forbidden], for: target_user) }
    end
  end # END USER CONTEXT

  context "for Courses" do
    let ( :course ) { @course_a}
    context "when the current_user is an admin, she" do
      let ( :user ) { @admin }
      it { expect(user).to have_ability(@ability_aliases[:read_write_destroy], for: course) }
      it { expect(user).to have_ability({evaluate: true}, for: course) }
      it { expect(user).to have_ability({show_submissions: true}, for: course) }
    end
    context "when the current_user is an admin for another org, she" do
      let ( :user ) { @admin_other_org }
      it { expect(user).to have_ability(@ability_aliases[:forbidden], for: course) }
      it { expect(user).to have_ability({evaluate: false}, for: course) }
      it { expect(user).to have_ability({show_submissions: false}, for: course) }
    end
    context "when the current_user is an evaluator for the course, she" do
      let ( :user ) { @evaluator_in_course_a }
      it { expect(user).to have_ability(@ability_aliases[:read_write], for: course) }
      it { expect(user).to have_ability({evaluate: true}, for: course) }
      it { expect(user).to have_ability({portfolio: false}, for: course) }
      it { expect(user).to have_ability({show_submissions: true}, for: course) }
    end
    context "when the current_user is a creator enrolled in the course, she" do
      let ( :user ) { @creator_in_course_a }
      it { expect(user).to have_ability(@ability_aliases[:read_only], for: course) }
      it { expect(user).to have_ability({evaluate: false}, for: course) }
      it { expect(user).to have_ability({portfolio: true}, for: course) }
      it { expect(user).to have_ability({show_submissions: false}, for: course) }
    end
    context "when the current_user is a creator not enrolled in the course, she" do
      let ( :user ) { @creator_in_course_b }
      it { expect(user).to have_ability(@ability_aliases[:forbidden], for: course) }
      it { expect(user).to have_ability({evaluate: false}, for: course) }
      it { expect(user).to have_ability({portfolio: false}, for: course) }
      it { expect(user).to have_ability({show_submissions: false}, for: course) }
    end
    context "when the course has a project with peer review enabled" do
      before (:each) {
        @first_project_in_course_a.settings['enable_peer_review'] = '1'
        @first_project_in_course_a.save
      }
      after (:each) {
        @first_project_in_course_a.settings['enable_peer_review'] = '0'
        @first_project_in_course_a.save
      }
      context "if the current_user is an evaluator for the course, she" do
        let ( :user ) { @evaluator_in_course_a }
        it { expect(user).to have_ability({show_submissions: true}, for: course) }
      end
      context "if the current_user is a creator enrolled in the course, she" do
        let ( :user ) { @creator_in_course_a }
        it {
          expect(user).to have_ability({show_submissions: true}, for: course)
        }
      end
      context "if the current_user is a creator not enrolled in the course, she" do
        let ( :user ) { @creator_in_course_b }
        it { expect(user).to have_ability({show_submissions: false}, for: course) }
      end
    end
    context "when the course has a project with public discussion enabled" do
      before (:each) {
        @first_project_in_course_a.settings['enable_public_discussion'] = '1'
        @first_project_in_course_a.save
      }
      after (:each) {
        @first_project_in_course_a.settings['enable_public_discussion'] = '0'
        @first_project_in_course_a.save
      }
      context "if the current_user is an evaluator for the course, she" do
        let ( :user ) { @evaluator_in_course_a }
        it { expect(user).to have_ability({show_submissions: true}, for: course) }
      end
      context "if the current_user is a creator enrolled in the course, she" do
        let ( :user ) { @creator_in_course_a }
        it {
          expect(user).to have_ability({show_submissions: true}, for: course)
        }
      end
      context "if the current_user is a creator not enrolled in the course, she" do
        let ( :user ) { @creator_in_course_b }
        it { expect(user).to have_ability({show_submissions: false}, for: course) }
      end
    end

  end # END COURSE CONTEXT

  context "for Projects" do
    let ( :project ) { @first_project_in_course_a}
    context "when the current_user is an admin, she" do
      let ( :user ) { @admin }
      it { expect(user).to have_ability(@ability_aliases[:read_write_destroy], for: project) }
      it { expect(user).to have_ability({submit: true}, for: project) }
    end
    context "when the current_user is an admin in another org, she" do
      let ( :user ) { @admin_other_org }
      it { expect(user).to have_ability(@ability_aliases[:forbidden], for: project) }
      it { expect(user).to have_ability({submit: false}, for: project) }
    end
    context "when the current_user is an evaluator for the course, she" do
      let ( :user ) { @evaluator_in_course_a }
      it { expect(user).to have_ability(@ability_aliases[:read_write_destroy], for: project) }
      it { expect(user).to have_ability({submit: false}, for: project) }
    end
    context "when the current_user is a creator enrolled in the course, she" do
      let ( :user ) { @creator_in_course_a }
      it { expect(user).to have_ability(@ability_aliases[:read_only], for: project) }
      it { expect(user).to have_ability({submit: true}, for: project) }
    end
    context "when the current_user is a creator not enrolled in the course, she" do
      let ( :user ) { @creator_in_course_b }
      it { expect(user).to have_ability(@ability_aliases[:forbidden], for: project) }
      it { expect(user).to have_ability({submit: false}, for: project) }
    end
  end # END PROJECT CONTEXT

  context "for Submissions" do

    let ( :submission ) { @submission_for_first_project_in_course_a }
    context "when Submission is a group submission" do
      let ( :submission ) { @group_submission_for_first_project_in_course_a }
      let ( :group ) { @first_group_in_course_a }

      context "if the current_user is a member of the group, she" do
        let ( :user ) { @creator_in_course_a }
        it { expect(user).to have_ability({belong_to: true}, for: group) }
        it { expect(user).to have_ability(@ability_aliases[:read_write], for: submission) }
        it { expect(user).to have_ability({own: true}, for: submission) }
        it { expect(user).to have_ability({annotate: true}, for: submission) }

        it { expect(user).to have_ability({evaluate: false}, for: submission) }
      end

      context "if the current_user is not a member of the group, she" do
        let ( :user ) { @another_creator_in_course_a }
        it { expect(user).to have_ability({belong_to: false}, for: group) }
        it { expect(user).to have_ability(@ability_aliases[:forbidden], for: submission) }
        it { expect(user).to have_ability({own: false}, for: submission) }
        it { expect(user).to have_ability({annotate: false}, for: submission) }
        it { expect(user).to have_ability({evaluate: false}, for: submission) }
      end
    end

    context "if the current_user is an admin, she" do
      let ( :user ) { @admin }
      it { expect(user).to have_ability(@ability_aliases[:read_write_destroy], for: submission) }
      it { expect(user).to have_ability({own: true}, for: submission) }
      it { expect(user).to have_ability({annotate: true}, for: submission) }
      it { expect(user).to have_ability({evaluate: false}, for: submission) }
    end
    context "if the current_user is an admin in another org, she" do
      let ( :user ) { @admin_other_org }
      it { expect(user).to have_ability(@ability_aliases[:forbidden], for: submission) }
      it { expect(user).to have_ability({own: false}, for: submission) }
      it { expect(user).to have_ability({annotate: false}, for: submission) }
      it { expect(user).to have_ability({evaluate: false}, for: submission) }
    end
    context "if the current_user is an evaluator for the course, she" do
      let ( :user ) { @evaluator_in_course_a }
      it { expect(user).to have_ability({evaluate: true}, for: submission) }
    end
    context "if the current_user is the submission creator, she" do
      let ( :user ) { @creator_in_course_a }
      it { expect(user).to have_ability(@ability_aliases[:read_write], for: submission) }
      it { expect(user).to have_ability({own: true}, for: submission) }
      it { expect(user).to have_ability({annotate: true}, for: submission) }
      it { expect(user).to have_ability({evaluate: false}, for: submission) }
    end
    context "if the current_user is another student in the course, but not the submission's creator, she" do
      let ( :user ) { @another_creator_in_course_a }
      it { expect(user).to have_ability(@ability_aliases[:forbidden], for: submission) }
      it { expect(user).to have_ability({own: false}, for: submission) }
      it { expect(user).to have_ability({annotate: false}, for: submission) }
      it { expect(user).to have_ability({evaluate: false}, for: submission) }
      it { expect(user).to have_ability(@ability_aliases[:read_only], for: submission.project.course) }
    end
    context "if the current_user is a creator not enrolled in the course, she" do
      let ( :user ) { @creator_in_course_b }
      it { expect(user).to have_ability(@ability_aliases[:forbidden], for: submission) }
      it { expect(user).to have_ability({show: false}, for: submission.project.course) }
      it { expect(user).to have_ability({own: false}, for: submission) }
      it { expect(user).to have_ability({annotate: false}, for: submission) }
      it { expect(user).to have_ability({evaluate: false}, for: submission) }
    end

    context "when the project has public discussion enabled" do
      before (:each) {
        @first_project_in_course_a.settings['enable_public_discussion'] = '1'
        @first_project_in_course_a.save
      }
      after (:each) {
        @first_project_in_course_a.settings['enable_public_discussion'] = '0'
        @first_project_in_course_a.save
      }
      context "if the current_user is an admin, she" do
        let ( :user ) { @admin }
        it { expect(user).to have_ability({discuss: true}, for: submission) }
      end
      context "if the current_user is an admin in another organization, she" do
        let ( :user ) { @admin_other_org }
        it { expect(user).to have_ability(@ability_aliases[:forbidden], for: submission) }
      end
      context "if the current_user is an evaluator for the course, she" do
        let ( :user ) { @evaluator_in_course_a }
        it { expect(user).to have_ability({discuss: true}, for: submission) }
      end
      context "if the current_user is the submission creator, she" do
        let ( :user ) { @creator_in_course_a }
        it { expect(user).to have_ability({discuss: true}, for: submission) }
      end
      context "if the current_user is another student in the course, but not the submission's creator, she" do
        let ( :user ) { @another_creator_in_course_a }
        it { expect(user).to have_ability({discuss: true}, for: submission) }
        it { expect(user).to have_ability({show: true}, for: submission.project.course) }
      end
      context "if the current_user is a creator not enrolled in the course, she" do
        let ( :user ) { @creator_in_course_b }
        it { expect(user).to have_ability({show: false}, for: submission.project.course) }
        it { expect(user).to have_ability({discuss: false}, for: submission) }
      end
    end

    context "when the project has public discussion disabled" do
      context "if the current_user is an admin, she" do
        let ( :user ) { @admin }
        it { expect(user).to have_ability({discuss: true}, for: submission) }
      end
      context "if the current_user is an admin in another org, she" do
        let ( :user ) { @admin_other_org }
        it { expect(user).to have_ability(@ability_aliases[:forbidden], for: submission) }
      end
      context "if the current_user is an evaluator for the course, she" do
        let ( :user ) { @evaluator_in_course_a }
        it { expect(user).to have_ability({discuss: true}, for: submission) }
      end
      context "if the current_user is the submission creator, she" do
        let ( :user ) { @creator_in_course_a }
        it { expect(user).to have_ability({discuss: true}, for: submission) }
      end
      context "if the current_user is another student in the course, but not the submission's creator, she" do
        let ( :user ) { @another_creator_in_course_a }
        it { expect(user).to have_ability({discuss: false}, for: submission) }
      end
      context "if the current_user is a creator not enrolled in the course, she" do
        let ( :user ) { @creator_in_course_b }
        it { expect(user).to have_ability({discuss: false}, for: submission) }
      end
    end

    context "when the project has creator attach enabled" do
      before (:each) {
        @first_project_in_course_a.settings['enable_creator_attach'] = '1'
        @first_project_in_course_a.save
      }
      after (:each) {
        @first_project_in_course_a.settings['enable_creator_attach'] = '0'
        @first_project_in_course_a.save
      }
      context "if the current_user is an admin, she" do
        let ( :user ) { @admin }
        it { expect(user).to have_ability({attach: true}, for: submission) }
      end
      context "if the current_user is an admin in another org, she" do
        let ( :user ) { @admin_other_org }
        it { expect(user).to have_ability(@ability_aliases[:forbidden], for: submission) }
      end
      context "if the current_user is an evaluator for the course, she" do
        let ( :user ) { @evaluator_in_course_a }
        it { expect(user).to have_ability({attach: true}, for: submission) }
      end
      context "if the current_user is the submission creator, she" do
        let ( :user ) { @creator_in_course_a }
        it { expect(user).to have_ability({attach: true}, for: submission) }
      end
      context "if the current_user is another student in the course, but not the submission's creator, she" do
        let ( :user ) { @another_creator_in_course_a }
        it { expect(user).to have_ability({attach: false}, for: submission) }
      end
      context "if the current_user is a creator not enrolled in the course, she" do
        let ( :user ) { @creator_in_course_b }
        it { expect(user).to have_ability({attach: false}, for: submission) }
      end
    end

    context "when the project has creator attach disabled" do
      context "if the current_user is an admin, she" do
        let ( :user ) { @admin }
        it { expect(user).to have_ability({attach: true}, for: submission) }
      end
      context "if the current_user is an admin in another org, she" do
        let ( :user ) { @admin_other_org }
        it { expect(user).to have_ability(@ability_aliases[:forbidden], for: submission) }
      end
      context "if the current_user is an evaluator for the course, she" do
        let ( :user ) { @evaluator_in_course_a }
        it { expect(user).to have_ability({attach: true}, for: submission) }
      end
      context "if the current_user is the submission creator, she" do
        let ( :user ) { @creator_in_course_a }
        it { expect(user).to have_ability({attach: false}, for: submission) }
      end
      context "if the current_user is another student in the course, but not the submission's creator, she" do
        let ( :user ) { @another_creator_in_course_a }
        it { expect(user).to have_ability({attach: false}, for: submission) }
      end
      context "if the current_user is a creator not enrolled in the course, she" do
        let ( :user ) { @creator_in_course_b }
        it { expect(user).to have_ability({attach: false}, for: submission) }
      end
    end

    context "when the project has peer review disabled" do
      context "and self evaluation is enabled" do
        before (:each) {
          @first_project_in_course_a.settings['enable_self_evaluation'] = '1'
          @first_project_in_course_a.save
        }
        after (:each) {
          @first_project_in_course_a.settings['enable_self_evaluation'] = '0'
          @first_project_in_course_a.save
        }
        context "if the current_user is the submission creator, she" do
          let ( :user ) { @creator_in_course_a }
          it { expect(user).to have_ability({annotate: true}, for: submission) }
          it { expect(user).to have_ability({evaluate: true}, for: submission) }
        end
      end
    end

    context "when the project has peer review enabled" do
      before (:each) {
        @first_project_in_course_a.settings['enable_peer_review'] = '1'
        @first_project_in_course_a.save
      }
      after (:each) {
        @first_project_in_course_a.settings['enable_peer_review'] = '0'
        @first_project_in_course_a.save
      }

      context "if the current_user is another student in the course, but not the submission's creator, she" do
        let ( :user ) { @another_creator_in_course_a }
        it {
          expect(user).to have_ability({:destroy => false}, for: submission)
        }

        it {
          expect(user).to have_ability(@ability_aliases[:read_only], for: submission)
        }
      end

      context "and self evaluation is enabled" do
        before (:each) {
          @first_project_in_course_a.settings['enable_self_evaluation'] = '1'
          @first_project_in_course_a.save
        }
        after (:each) {
          @first_project_in_course_a.settings['enable_self_evaluation'] = '0'
          @first_project_in_course_a.save
        }
        context "if the current_user is the submission creator, she" do
          let ( :user ) { @creator_in_course_a }
          it { expect(user).to have_ability({evaluate: true}, for: submission) }
        end
      end

      context "if the current_user is the submission creator, she" do
        let ( :user ) { @creator_in_course_a }
        it { expect(user).to have_ability({own: true}, for: submission) }
        it { expect(user).to have_ability({annotate: true}, for: submission) }
        it { expect(user).to have_ability({evaluate: false}, for: submission) }
      end
      context "if the current_user is another student in the course, but not the submission's creator, she" do
        let ( :user ) { @another_creator_in_course_a }
        it { expect(user).to have_ability({annotate: true}, for: submission) }
        it { expect(user).to have_ability({evaluate: true}, for: submission) }
      end
    end
  end # END SUBMISSION CONTEXT

  context "for Groups" do
    let ( :group ) { @first_group_in_course_a}
    context "if the current_user is an admin, she" do
      let ( :user ) { @admin }
      it { expect(user).to have_ability(@ability_aliases[:read_write_destroy], for: group) }
    end
    context "if the current_user is an admin in another org, she" do
      let ( :user ) { @admin_other_org }
      it { expect(user).to have_ability(@ability_aliases[:forbidden], for: group) }
    end
    context "if the current_user is evaluator for the course, she" do
      let ( :user ) { @evaluator_in_course_a }
      it { expect(user).to have_ability(@ability_aliases[:read_write_destroy], for: group) }
    end
    context "if the current_user is a creator in the course that belongs to the group, she" do
      let ( :user ) { @creator_in_course_a }
      it { expect(user).to have_ability(@ability_aliases[:read_only], for: group) }
    end
    context "if the current_user is a creator in the course that does not belong to the group, she" do
      let ( :user ) { @another_creator_in_course_a }
      it { expect(user).to have_ability(@ability_aliases[:read_only], for: group) }
    end
    context "if the current user is a creator not enrolled in the course, she" do
      let ( :user ) { @creator_in_course_b }
      it { expect(user).to have_ability(@ability_aliases[:forbidden], for: group) }
    end
  end # END GROUPS CONTEXT

  context "for DiscussionPosts" do
    context "when the post was created by a creator" do
      let ( :post ) { FactoryGirl.build(:discussion_post, author: @creator_in_course_a, submission: @submission_for_first_project_in_course_a ) }
      context "if the current_user is an admin, she" do
        let ( :user ) { @admin }
        it { expect(user).to have_ability(@ability_aliases[:read_write_destroy], for: post) }
      end
      context "if the current_user is an admin in another org, she" do
        let ( :user ) { @admin_other_org }
        it { expect(user).to have_ability(@ability_aliases[:forbidden], for: post) }
      end
      context "if the current_user is evaluator for the course, she" do
        let ( :user ) { @evaluator_in_course_a }
        it { expect(user).to have_ability(@ability_aliases[:read_write_destroy], for: post) }
      end
      context "if the current_user is a creator and the author of the post, she" do
        let ( :user ) { @creator_in_course_a }
        it { expect(user).to have_ability(@ability_aliases[:read_write], for: post) }
        it { expect(user).to have_ability({:create => true}, for: post) }
      end
      context "if the current_user is a creator and not the author of the post, she" do
        let ( :user ) { @another_creator_in_course_a }
        it { expect(user).to have_ability(@ability_aliases[:forbidden], for: post) }
      end
      context "if the current user is a creator not enrolled in the course, she" do
        let ( :user ) { @creator_in_course_b }
        it { expect(user).to have_ability(@ability_aliases[:forbidden], for: post) }
      end
    end

    context "when the post was authored by an evaluator" do
      let ( :post ) { FactoryGirl.build(:discussion_post, author: @evaluator_in_course_a, submission: @submission_for_first_project_in_course_a ) }
      context "if the current_user is an admin, she" do
        let ( :user ) { @admin }
        it { expect(user).to have_ability(@ability_aliases[:read_write_destroy], for: post) }
      end
      context "if the current_user is an admin in another org, she" do
        let ( :user ) { @admin_other_org }
        it { expect(user).to have_ability(@ability_aliases[:forbidden], for: post) }
      end
      context "if the current_user is evaluator for the course, she" do
        let ( :user ) { @evaluator_in_course_a }
        it { expect(user).to have_ability(@ability_aliases[:read_write_destroy], for: post) }
      end
      context "if the current_user is the creator associated with the post's submission, she" do
        let ( :user ) { @creator_in_course_a }
        it { expect(user).to have_ability(@ability_aliases[:read_create_only], for: post) }
      end
      context "if the current_user is a creator and is not associated with the post's submission, she" do
        let ( :user ) { @another_creator_in_course_a }
        it { expect(user).to have_ability(@ability_aliases[:forbidden], for: post) }
      end
      context "if the current user is a creator not enrolled in the course, she" do
        let ( :user ) { @creator_in_course_b }
        it { expect(user).to have_ability(@ability_aliases[:forbidden], for: post) }
      end
    end
  end # END DISCUSSION POST CONTEXT

  context "for Annotations" do

    context "when the annotation was created by a creator" do
      let ( :annotation ) { FactoryGirl.build(:annotation, author: @creator_in_course_a, asset: FactoryGirl.build(:asset, submission: @submission_for_first_project_in_course_a)) }
      context "if the current_user is an admin, she" do
        let ( :user ) { @admin }
        it { expect(user).to have_ability(@ability_aliases[:read_write_destroy], for: annotation) }
      end
      context "if the current_user is an admin in another org, she" do
        let ( :user ) { @admin_other_org }
        it { expect(user).to have_ability(@ability_aliases[:forbidden], for: annotation) }
      end
      context "if the current_user is an evaluator for the course, she" do
        let ( :user ) { @evaluator_in_course_a }
        it { expect(user).to have_ability(@ability_aliases[:read_write_destroy], for: annotation) }
      end
      context "if the current_user is a creator and the author of the annotation, she" do
        let ( :user ) { @creator_in_course_a }
        it { expect(user).to have_ability(@ability_aliases[:read_write_destroy], for: annotation) }
      end
      context "if current_user is another user in the course, but not the submission creator or the annotation creator" do
        let ( :user ) { @creator_in_course_b }
        it { expect(user).to have_ability(@ability_aliases[:forbidden], for: annotation) }
      end
    end
    context "when the annotation was created by an evaluator" do
      let ( :annotation ) { FactoryGirl.build(:annotation, author: @evaluator_in_course_a, asset: FactoryGirl.build(:asset, submission: @submission_for_first_project_in_course_a)) }
      context "if the current_user is an admin, she" do
        let ( :user ) { @admin }
        it { expect(user).to have_ability(@ability_aliases[:read_write_destroy], for: annotation) }
      end
      context "if the current_user is an admin in another org, she" do
        let ( :user ) { @admin_other_org }
        it { expect(user).to have_ability(@ability_aliases[:forbidden], for: annotation) }
      end
      context "if the current_user is an evaluator for the course, she" do
        let ( :user ) { @evaluator_in_course_a }
        it { expect(user).to have_ability(@ability_aliases[:read_write_destroy], for: annotation) }
      end
      context "if the current_user is the creator of the submission with which the annotation is associated, she" do
        let ( :user ) { @creator_in_course_a }
        it { expect(user).to have_ability(@ability_aliases[:read_create_only], for: annotation) }
      end
      context "if the current_user is not the creator of the submission with which the annotation is associated, she" do
        let ( :user ) { @creator_in_course_b }
        it { expect(user).to have_ability(@ability_aliases[:forbidden], for: annotation) }
      end
    end

  end # END ANNOTATIONS CONTEXT

  context "Assets" do
    let ( :asset ) { FactoryGirl.build(:asset, submission: @submission_for_first_project_in_course_a) }
    context "when the course has creator attach disabled" do
      context "if the current_user is an admin, she" do
        let ( :user ) { @admin }
        it { expect(user).to have_ability(@ability_aliases[:read_write_destroy], for: asset) }
      end
      context "if the current_user is an admin in another org, she" do
        let ( :user ) { @admin_other_org }
        it { expect(user).to have_ability(@ability_aliases[:forbidden], for: asset) }
      end
      context "if the current_user is an evaluator in the course, she" do
        let ( :user ) { @evaluator_in_course_a }
        it { expect(user).to have_ability(@ability_aliases[:read_write_destroy], for: asset) }
        it { expect(user).to have_ability({new: true}, for: asset) }
        it { expect(user).to have_ability({create: true}, for: asset) }
      end
      context "if the current_user is the creator for the submission with which the asset is associated, she" do
        let ( :user ) { @creator_in_course_a }
        it { expect(user).to have_ability(@ability_aliases[:read_only], for: asset) }
      end
      context "if current_user is enrolled in the course but is not the creator of the submission with which the asset is associated, then she" do
        let ( :user ) { @creator_in_course_b }
        it { expect(user).to have_ability(@ability_aliases[:forbidden], for: asset) }
      end
    end
    context "when the course has creator attach enabled" do
      before (:each) {
        @first_project_in_course_a.settings['enable_creator_attach'] = '1'
        @first_project_in_course_a.save
      }
      after (:each) {
        @first_project_in_course_a.settings['enable_creator_attach'] = '0'
        @first_project_in_course_a.save
      }
      context "if the current_user is an admin, she" do
        let ( :user ) { @admin }
        it { expect(user).to have_ability(@ability_aliases[:read_write_destroy], for: asset) }
      end
      context "if the current_user is an admin in another org, she" do
        let ( :user ) { @admin_other_org }
        it { expect(user).to have_ability(@ability_aliases[:forbidden], for: asset) }
      end
      context "if the current_user is an evaluator in the course, she" do
        let ( :user ) { @evaluator_in_course_a }
        it { expect(user).to have_ability(@ability_aliases[:read_write_destroy], for: asset) }
      end
      context "if the current_user is the creator for the submission with which the asset is associated, she" do
        let ( :user ) { @creator_in_course_a }
        it { expect(user).to have_ability(@ability_aliases[:read_write_destroy], for: asset) }
      end
      context "if current_user is enrolled in the course but is not the creator of the submission with which the asset is associated, then she" do
        let ( :user ) { @creator_in_course_b }
        it { expect(user).to have_ability(@ability_aliases[:forbidden], for: asset) }
      end
    end

    context "when the course has peer review enabled" do
      before (:each) {
        @first_project_in_course_a.settings['enable_peer_review'] = '1'
        @first_project_in_course_a.save
      }
      after (:each) {
        @first_project_in_course_a.settings['enable_peer_review'] = '0'
        @first_project_in_course_a.save
      }
      context "if current_user is enrolled in the course but is not the creator of the submission with which the asset is associated, then she" do
        let ( :user ) { @another_creator_in_course_a }
        it { expect(user).to have_ability(@ability_aliases[:read_only], for: asset) }
      end
    end

  end # END ASSETS CONTEXT

  context "for Rubrics" do
    context "when the rubric is an evaluator owned rubric" do
      let ( :rubric ) { FactoryGirl.build(:rubric, owner: @evaluator_in_course_a, organization: @org_a, public: false)}
      context "if the current_user is an admin, she" do
        let ( :user ) { @admin }
        it { expect(user).to have_ability(@ability_aliases[:read_write_destroy], for: rubric) }
      end
      context "if the current_user is an admin in another org, she" do
        let ( :user ) { @admin_other_org }
        it { expect(user).to have_ability(@ability_aliases[:forbidden], for: rubric) }
      end
      context "if the current_user is the evaluator that owns it, she" do
        let ( :user ) { @evaluator_in_course_a }
        it { expect(user).to have_ability(@ability_aliases[:read_write_destroy], for: rubric) }
        it { expect(user).to have_ability({new: true}, for: Rubric) }
        it { expect(user).to have_ability({create: true}, for: Rubric) }
      end
      context "if the current_user is a creator, she" do
        let ( :user ) { @creator_in_course_a }
        it { expect(user).to have_ability(@ability_aliases[:read_only], for: rubric) }
      end
    end
    context "when the rubric is an admin owned rubric" do
      let ( :rubric ) { FactoryGirl.build(:rubric, owner: @admin, organization: @org_a, public: true)}
      context "if the current_user is an admin, she" do
        let ( :user ) { @admin }
        it { expect(user).to have_ability(@ability_aliases[:read_write_destroy], for: rubric) }
      end
      context "if the current_user is the evaluator that owns it, she" do
        let ( :user ) { @evaluator_in_course_a }
        it { expect(user).to have_ability({index: true, show: true, edit: false, new: true, create: true, update: false, destroy: false}, for: rubric) }
      end
      context "if the current_user is a creator, she" do
        let ( :user ) { @creator_in_course_a }
        it { expect(user).to have_ability(@ability_aliases[:read_only], for: rubric) }
      end
    end
  end # END RUBRICS CONTEXT

  context "for Evaluations" do
    context "when Evaluation is published and belongs to course evaluator" do
      let ( :evaluation ) { FactoryGirl.build(:evaluation, evaluator: @evaluator_in_course_a, published: true, submission: @submission_for_first_project_in_course_a)}
      context "if the current_user is an admin, she" do
        let ( :user ) { @admin }
        it { expect(user).to have_ability(@ability_aliases[:read_only], for: evaluation) }
      end
      context "if the current_user is an admin in another org, she" do
        let ( :user ) { @admin_other_org }
        it { expect(user).to have_ability(@ability_aliases[:forbidden], for: evaluation) }
      end

      context "if the current_user is the owner of the evaluation, she" do
        let ( :user ) { @evaluator_in_course_a }
        it { expect(user).to have_ability(@ability_aliases[:read_write_destroy], for: evaluation) }
      end
      context "if the current_user is the creator of the submission being evaluated, she" do
        let ( :user ) { @creator_in_course_a }
        it { expect(user).to have_ability(@ability_aliases[:read_only], for: evaluation) }
      end
      context "if current_user is another creator in the course, she" do
        let ( :user ) { @creator_in_course_b }
        it { expect(user).to have_ability(@ability_aliases[:forbidden], for: evaluation) }
      end
    end

    context "when Evaluation is a new evaluation where evaluator == nil" do
      let ( :evaluation ) { FactoryGirl.build(:evaluation, evaluator: nil, published: false, submission: @submission_for_first_project_in_course_a)}
      context "if the current_user can evaluate the submission, she" do
        let ( :user ) { @evaluator_in_course_a }
        it { expect(user).to have_ability({new: true, create: true}, for: evaluation) }
      end
    end

    context "when Evaluation is published and belongs to course evaluator" do
      let ( :evaluation ) { FactoryGirl.build(:evaluation, evaluator: @evaluator_in_course_a, published: false, submission: @submission_for_first_project_in_course_a)}
      context "if the current_user is an admin, she" do
        let ( :user ) { @admin }
        it { expect(user).to have_ability(@ability_aliases[:read_only], for: evaluation) }
      end
      context "if the current_user is the owner of the evaluation, she" do
        let ( :user ) { @evaluator_in_course_a }
        it { expect(user).to have_ability(@ability_aliases[:read_write_destroy], for: evaluation) }
      end
      context "if the current_user is the creator of the submission being evaluated, she" do
        let ( :user ) { @creator_in_course_a }
        it { expect(user).to have_ability(@ability_aliases[:forbidden], for: evaluation) }
      end
      context "if current_user is another creator in the course, she" do
        let ( :user ) { @creator_in_course_b }
        it { expect(user).to have_ability(@ability_aliases[:forbidden], for: evaluation) }
      end
    end

    # TODO: We probably need a little bit more thorough evaluation specs.

  end

end

