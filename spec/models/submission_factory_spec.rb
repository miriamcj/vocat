require 'spec_helper'

describe 'SubmissionFactory' do

  before(:each) do
    @factory = SubmissionFactory.new
    @course = FactoryGirl.create :course
    @user_1 = FactoryGirl.create(:creator, email: 'creator@test.com', creator_courses: [@course] )
    @user_2 = FactoryGirl.create(:creator, email: 'another_creator@test.com', creator_courses: [@course] )

    @group_1 = FactoryGirl.create :group, name: 'group #1', course: @course, creators: [@user_1, @user_2]
    @group_2 = FactoryGirl.create :group, name: 'group #2', course: @course, creators: [@user_1]
    @group_3 = FactoryGirl.create :group, name: 'group #3', course: @course

    @user_project_1 = FactoryGirl.create(:project, project_type: 'user', name: 'user project', course: @course)
    @user_project_2 = FactoryGirl.create(:project, project_type: 'user', name: 'another user project', course: @course)

    @group_project_1 = FactoryGirl.create(:project, project_type: 'group', name: 'group project #1', course: @course)
    @group_project_2 = FactoryGirl.create(:project, project_type: 'group', name: 'group project #2', course: @course)
    @group_project_3 = FactoryGirl.create(:project, project_type: 'group', name: 'group project #3', course: @course)

    @all_project_1 = FactoryGirl.create(:project, project_type: 'any', name: 'all project #1', course: @course)
  end

  it 'should return the correct number of submissions for a given course' do
    # 2 users * 2 user projects = 4 submissions
    # 3 groups * 3 group projects = 9 submissions
    # 3 group * 1 all project = 3 submission
    # 2 users * 1 all project = 2 submission
    # 4 + 9 + 3 + 2 = 18 submissions
    submissions = @factory.course(@course)
    expect(submissions.length).to eq 18
  end

  it 'should return an iterable object when course method is called' do
    submissions = @factory.course(@course)
    expect(submissions.respond_to?(:each)).to be_true
  end

  it 'should return an iterable object when course_and_creator method is called' do
    submissions = @factory.course_and_creator(@course, @user_1)
    expect(submissions.respond_to?(:each)).to be_true
  end

  it 'should return an iterable object when course_and_project method is called' do
    submissions = @factory.creator_and_project(@user_1, @user_project_1)
    expect(submissions.respond_to?(:each)).to be_true
  end

  it 'should return the correct number of submissions for a given course and user' do
    # This should include the group submissions for groups to which this user belongs.
    # user_1 has 2 user projects = 2
    # user_1 has 1 all project = 1
    # user_1 belongs to 2 groups, each of which has 3 group projects = 6
    # user_1 belongs to 2 groups, each of which has 1 all project = 2
    # 2 + 1 + 6 + 2 = 11
    submissions = @factory.course_and_creator(@course, @user_1)
    expect(submissions.length).to eq 11
  end

  it 'should return the correct number of submissions for a given course and group' do
    # 3 group projects + 1 all project = 4 submissions
    submissions = @factory.course_and_creator(@course, @group_1)
    expect(submissions.length).to eq 4
  end

  it 'should return the correct number of submissions for a user and a user project' do
    submissions = @factory.creator_and_project(@user_1, @user_project_1)
    expect(submissions.length).to eq 1
  end

  it 'should return the correct number of submissions for a group and a user project' do
    submissions = @factory.creator_and_project(@group_1, @user_project_1)
    expect(submissions.length).to eq 0
  end

  it 'should return the correct number of submissions for a user and a group project' do
    # User 1 is in group_1 and group_2, so we should get 2 group submissions for this project.
    submissions = @factory.creator_and_project(@user_1, @group_project_1)
    expect(submissions.length).to eq 2
  end

  it 'should return the correct number of submissions for a group and a group project' do
    submissions = @factory.creator_and_project(@group_1, @group_project_1)
    expect(submissions.length).to eq 1
  end

  it 'should return the correct number of submissions for a group and an all project' do
    submissions = @factory.creator_and_project(@group_1, @all_project_1)
    expect(submissions.length).to eq 1
  end

  it 'should return the correct number of submissions for a user in groups and an all project' do
    # user_1 will have 1 individual submission for this project
    # user_1 belongs to 2 groups, each of which will also have a submission for this project
    # 1 + 2 = 3
    submissions = @factory.creator_and_project(@user_1, @all_project_1)
    expect(submissions.length).to eq 3
  end

  it 'should return the correct number of submissions for a user not in groups and an all project' do
    # user_1 will have 1 individual submission for this project
    # user_1 belongs to 1 group, each of which will also have a submission for this project
    # 1 + 1 = 2
    submissions = @factory.creator_and_project(@user_2, @all_project_1)
    expect(submissions.length).to eq 2
  end

  it 'should return the correct number of submissions for a user project' do
    # There are 2 users, so this project should have 2 submissions.
    submissions = @factory.project(@user_project_1)
    expect(submissions.length).to eq 2
  end

  it 'should return the correct number of submissions for a group project' do
    # 3 groups on a single group project should return 3 submissions
    submissions = @factory.project(@group_project_1)
    expect(submissions.length).to eq 3
  end

  it 'should return the correct number of submissions for an all project' do
    # 3 groups + 2 users = 5
    submissions = @factory.project(@all_project_1)
    expect(submissions.length).to eq 5
  end





end