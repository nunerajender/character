namespace :analytics do
  desc "Update daily report"
  task :daily => :environment do
    Reports::AnalyticsDaily.update_report_for_today()
  end
end