require 'csv'
class Admin::ReportsController < ApplicationController

  before_filter do
    if params[:format] && ['json', 'csv', 'text'].include?(params[:format].downcase)
      request.format = params[:format].downcase
    end
  end

  load_and_authorize_resource :course, :parent => false, if: lambda {
    action_name.start_with?('course_')
  }
  load_and_authorize_resource :rubric, :parent => false, if: lambda {
    action_name.start_with?('rubric_')
  }
  respond_to :json
  respond_to :csv
  respond_to :text

  def scores

  end

  def course_roster
    respond_with @course.creators do |format|
      format.csv do
        send_data(csv_for(@course.creators), :type => 'text/csv', :filename => @course.format('%d%n_%s_roster.csv'))
      end
    end
  end

  def rubric_scores
    respond_with @rubric.evaluations_filtered(params) do |format|
      format.csv do
        send_data(csv_for(@rubric.evaluations), :type => 'text/csv', :filename => "rubric_#{@rubric.id}_scores.csv")
      end
    end
  end

  def course_scores
    @evaluations = Evaluation.by_course(@course).includes(:submission => :creator)
    respond_with @evaluations do |format|
      format.csv do
        send_data(csv_for(@evaluations), :type => 'text/csv', :filename => @course.format('%d%n_%s_scores.csv'))
      end
    end
  end

  def csv_for(models)
    (output = "").tap do
      CSV.generate(output) do |csv|
        if models.length > 0
          csv << models[0].to_csv_header_row
        end
        models.each do |model|
          csv << model.to_csv()
        end
      end
    end
  end

end