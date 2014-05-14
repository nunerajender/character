@Character.Dashboard.Charts ||= {}
@Character.Dashboard.Charts.visitors = (layout) ->
  title = 'Visitors'
  color = '#fac043'

  if layout.chartType() == 'day'
    reportModel = 'Reports-AnalyticsDaily'
    dateFormat = (d) -> moment(d).format("MMM D")
  else if layout.chartType() == 'week'
    reportModel = 'Reports-AnalyticsWeekly'
    dateFormat = (d) ->
      weekStart = moment(d).format("MMM D")
      weekEnd   = moment(d).add('days', 6).format("MMM D")
      "#{weekStart} - #{weekEnd}"
  else if layout.chartType() == 'month'
    reportModel = 'Reports-AnalyticsMonthly'
    dateFormat = (d) -> moment(d).format("MMM YYYY")

  fields    = [ 'visitors' ].join(',')
  startDate = layout.dateFrom()
  stopDate  = layout.dateTo()

  url = "/admin/#{reportModel}?f=#{fields}&where__report_date=$gte:#{ startDate },$lte:#{ stopDate }&o=report_date:asc&pp=40"

  $.get url, {}, (data) =>
    d = _.map data, (r) -> { y: dateFormat(r.report_date), a: r.visitors }
    layout.drawBarChart title, color, d
