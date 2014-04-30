# encoding: UTF-8
module Report
  extend ActiveSupport::Concern

  included do
    field                 :report_date, type: Date
    validates_presence_of :report_date

    default_scope -> { order_by(report_date: :asc) }
  end
end