# encoding: UTF-8
module ReportWeekly
  extend ActiveSupport::Concern

  included do
    include Report
  end

  module ClassMethods
    def update_current_report
      today          = Date.today
      week_day       = today.cwday # Mon is 1
      closest_monday = today - (week_day - 1).day
      report = self.find_or_create_by(report_date: closest_monday)
      report.update_report!()
      return report
    end
  end
end