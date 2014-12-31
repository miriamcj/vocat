require 'spec_helper'

describe Reporter::Project do

  before(:all) do
    @course = FactoryGirl.create(:course)
    @creator = FactoryGirl.create(:creator, first_name: 'Creator', last_name: 'User', email: 'creator@test.com')
    @peer_1 = FactoryGirl.create(:creator, first_name: 'Peer1', last_name: 'User', email: 'peer1@test.com')
    @peer_2 = FactoryGirl.create(:creator, first_name: 'Peer2', last_name: 'User', email: 'peer2@test.com')
    @evaluator = FactoryGirl.create(:evaluator, first_name: 'Evaluator', last_name: 'User', email: 'evaluator@test.com')
    @course.enroll(@creator)
    @course.enroll(@peer_1)
    @course.enroll(@peer_2)
    @course.enroll(@evaluator)
    @project = FactoryGirl.create(:project, course: @course)
    @project_sans_rubric = FactoryGirl.create(:project, course: @course, rubric: nil)
    @submission = FactoryGirl.create(:submission, creator: @creator, project: @project)

    @peer_evaluations = []
    @self_evaluations = []
    @evaluator_evaluations = []
    @peer_evaluations << FactoryGirl.create(:evaluation, submission: @submission, evaluator: @peer_1)
    @peer_evaluations << FactoryGirl.create(:evaluation, submission: @submission, evaluator: @peer_2)
    @self_evaluations << FactoryGirl.create(:evaluation, submission: @submission, evaluator: @creator)
    @evaluator_evaluations << FactoryGirl.create(:evaluation, submission: @submission, evaluator: @evaluator)
    @all_evaluations = @peer_evaluations + @self_evaluations + @evaluator_evaluations
  end

  it 'throws an exception if instantiated without a project' do
    expect { Reporter::Project.new }.to raise_error
  end

  it 'reports the correct number of peer scores' do
    reporter = Reporter::Project.new(@project, 'json')
    expect(reporter.peer_scores.rows.size).to eq @peer_evaluations.size
  end

  it 'reports the correct number of evaluator scores' do
    reporter = Reporter::Project.new(@project, 'json')
    expect(reporter.evaluator_scores.rows.size).to eq @evaluator_evaluations.size
  end

  it 'reports the correct number of self evaluation scores' do
    reporter = Reporter::Project.new(@project, 'json')
    expect(reporter.self_scores.rows.size).to eq @self_evaluations.size
  end

  it 'reports the correct number of all scores' do
    reporter = Reporter::Project.new(@project, 'json')
    expect(reporter.all_scores.rows.size).to eq @all_evaluations.size
  end

  it 'does not throw an exception if the project has no rubric' do
    reporter = Reporter::Project.new(@project_sans_rubric, 'json')
    expect { reporter.peer_scores }.to_not raise_error
  end

  it 'returns a report with no rows if the project has no rubric' do
    reporter = Reporter::Project.new(@project_sans_rubric, 'json')
    expect(reporter.peer_scores.rows.size).to eq 0
  end

  it 'returns a report object with headers and rows that are arrays' do
    reporter = Reporter::Project.new(@project, 'json')
    expect(reporter.new_report.rows).to be_a Array
    expect(reporter.new_report.headers).to be_a Array
  end

end