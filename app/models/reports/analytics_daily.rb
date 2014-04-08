# encoding: UTF-8
module Reports
  class AnalyticsDaily
    include Mongoid::Document
    include Mongoid::Timestamps
    include ReportDaily

    field :visitors, type: Integer, default: 0

    def update_report!
      previous_report = self.previous_report
      current_report  = self

      date1    = previous_report.report_date.strftime("%Y-%m-%d")
      date2    = current_report.report_date.strftime("%Y-%m-%d")
      ga       = ::GoogleAnalytics.new()
      visitors = ga.visitors(date1, date2)

      previous_report.visitors = visitors[date1]
      current_report.visitors  = visitors[date2]

      previous_report.save!
      current_report.save!
    end
  end
end