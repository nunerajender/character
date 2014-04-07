# encoding: UTF-8
module Reports
  class AnalyticsDaily
    include Mongoid::Document
    include Mongoid::Timestamps
    include ReportDaily

    field :visitors, type: Integer, default: 0

    def update_report!
      ga        = GoogleAnalytics.new()
      yesterday = Date.yesterday.strftime("%Y-%m-%d")
      today     = Date.today.strftime("%Y-%m-%d")
      visitors  = ga.visitors(yesterday, today)

      yesterday_report = Reports::AnalyticsDaily.update_report_for(Date.yesterday)
      today_report     = this

      yesterday_report.visitors = visitors[yesterday]
      today_report.visitors     = visitors[today]

      yesterday_report.save!
      today_report.save!
    end
  end
end