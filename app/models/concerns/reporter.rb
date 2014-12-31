require 'csv'

module Reporter

  extend ActiveSupport::Concern

  def new_report
    OpenStruct.new(:rows => [], :headers => [])
  end

  def csv_for(report)
    output = CSV.generate do |csv|
      csv << report.headers
      report.rows.each do |row|
        csv << row
      end
    end
    output
  end

end

