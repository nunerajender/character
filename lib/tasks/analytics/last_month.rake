namespace :analytics do
  desc "Generate reports for last month"
  task :last_month => :environment do
    date1    = 1.month.ago.to_date.strftime("%Y-%m-%d")
    date2    = Date.today.strftime("%Y-%m-%d")
    ga       = ::GoogleAnalytics.new()
    visitors = ga.visitors(date1, date2)

    (1.month.ago.to_date..Date.today).each do |d|
      report = Reports::AnalyticsDaily.find_or_create_by(report_date: d)
      report.visitors = visitors[d.strftime("%Y-%m-%d")]
      report.save
    end
  end
end