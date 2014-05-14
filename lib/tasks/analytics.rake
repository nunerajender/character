namespace :analytics do
  desc "Update analytics reports for today"
  task :daily => :environment do
    Reports::AnalyticsDaily.update_report_for_today()
    Reports::AnalyticsWeekly.update_current_report()
    Reports::AnalyticsMonthly.update_current_report()
  end

  desc "Update all analytics reports (back to MONTHS=3)"
  task :regenerate => :environment do
    months_ago = ENV['MONTHS'] ? ENV['MONTHS'].to_i : 3

    # daily reports
    Reports::AnalyticsDaily.delete_all

    date1    = months_ago.month.ago.to_date.strftime("%Y-%m-%d")
    date2    = Date.today.strftime("%Y-%m-%d")
    ga       = ::GoogleAnalytics.new()
    visitors = ga.visitors(date1, date2)

    (months_ago.month.ago.to_date..Date.today).each do |d|
      report = Reports::AnalyticsDaily.find_or_create_by(report_date: d)
      report.visitors = visitors[d.strftime("%Y-%m-%d")]
      report.save
    end

    # weekly reports
    Reports::AnalyticsWeekly.delete_all

    today          = Date.today
    week_day       = today.cwday # Mon is 1
    closest_monday = today - (week_day - 1).day

    monday   = closest_monday
    end_date = months_ago.month.ago

    while end_date < monday do
      monday -= 7.days
      report = Reports::AnalyticsWeekly.find_or_create_by(report_date: monday)
      report.update_report!
    end

    # monthly reports
    Reports::AnalyticsMonthly.delete_all

    (0..months_ago).to_a.reverse.each do |delta|
      date = Date.today - delta.months
      report = Reports::AnalyticsMonthly.find_or_create_by(report_date: date)
      report.update_report!
    end
  end
end