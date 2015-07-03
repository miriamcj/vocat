class Courses::Export::ProjectsController < ApplicationController

  respond_to :json
  respond_to :csv

  before_action do
    if params[:format] && ['json', 'csv'].include?(params[:format].downcase)
      request.format = params[:format].downcase
    end
  end

  before_action do
    @project = Project.find(params[:id])
    org_validate_project
    authorize!(:export, @project)
  end

  def peer_scores
    reporter = Reporter::Project.new(@project, request.format)
    return_response(reporter, reporter.peer_scores, "peer_scores_project_#{@project.id}.csv")
  end

  def evaluator_scores
    reporter = Reporter::Project.new(@project, request.format)
    return_response(reporter, reporter.evaluator_scores, "evaluator_scores_project_#{@project.id}.csv")
  end

  def all_scores
    reporter = Reporter::Project.new(@project, request.format)
    return_response(reporter, reporter.all_scores, "all_scores_project_#{@project.id}.csv")
  end

  def self_scores
    reporter = Reporter::Project.new(@project, request.format)
    return_response(reporter, reporter.self_scores, "self_scores_project_#{@project.id}.csv")
  end

  protected

  def return_response(reporter, report, file_name)
    respond_with report.rows do |format|
      format.csv do
        send_data(reporter.csv_for(report), :type => 'text/html', :filename => file_name)
      end
    end
  end

end
