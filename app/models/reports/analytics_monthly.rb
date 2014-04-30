# encoding: UTF-8
module Reports
  class AnalyticsMonthly
    include Mongoid::Document
    include Mongoid::Timestamps
    include ReportMonthly

    field :visitors, type: Integer, default: 0

    def update_report!
      daily_reports = AnalyticsDaily.gte(report_date: report_date).lte(report_date: report_date + 1.month - 1.day)
      self.visitors = daily_reports.sum(:visitors)
      self.save!
    end
  end
end