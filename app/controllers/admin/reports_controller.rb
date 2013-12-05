require 'csv'
class Admin::ReportsController < ApplicationController

  load_and_authorize_resource :course, :parent => false
  respond_to :json
  respond_to :csv
  respond_to :text

  def scores

  end

  def roster
    respond_with @course.creators do |format|
      format.csv do
        send_data(csv_for(@course.creators), :type => 'text/csv', :filename => @course.format('%d%n_%s_roster.csv'))
      end
    end
  end

  def scores
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
        csv << models[0].to_csv_header_row
        models.each do |model|
          csv << model.to_csv()
        end
      end
    end
  end

end