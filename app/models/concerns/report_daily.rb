# encoding: UTF-8
module ReportDaily
  extend ActiveSupport::Concern

  included do
    field                 :report_date, type: Date
    validates_presence_of :report_date

    default_scope -> { order_by(report_date: :asc) }
  end

  def start_datetime
    DateTime.new(report_date.year, report_date.month, report_date.day, 0, 0, 0)
  end

  def end_datetime
    DateTime.new(report_date.year, report_date.month, report_date.day, 23, 59, 59)
  end

  def previous_report
    self.class.where(report_date: report_date - 1.day).first
  end

  module ClassMethods
    def update_report_for(date)
      report = self.find_or_create_by(report_date: date)
      report.update_report!()
      return report
    end

    def update_report_for_today()
      return self.update_report_for(Date.today)
    end
  end
end