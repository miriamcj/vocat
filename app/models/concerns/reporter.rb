require 'csv'

module Reporter

  extend ActiveSupport::Concern

  def new_report
    Struct.new('VocatReport', :rows, :headers)
    Struct::VocatReport.new([], [])
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

