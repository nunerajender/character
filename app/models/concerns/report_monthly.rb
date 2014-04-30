# encoding: UTF-8
module ReportMonthly
  extend ActiveSupport::Concern

  included do
    include Report
  end

  module ClassMethods
    def update_current_report
      today  = Date.today
      date   = DateTime.new(today.year, today.month, 1)
      report = self.find_or_create_by(report_date: date)
      report.update_report!()
      return report
    end
  end
end