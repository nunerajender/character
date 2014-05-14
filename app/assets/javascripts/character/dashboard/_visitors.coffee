@Character.Dashboard.Charts ||= {}
@Character.Dashboard.Charts.visitors = (layout) ->
  title = 'Visitors'
  color = '#fac043'

  if layout.chartType() == 'day'
    reportModel = 'Reports-AnalyticsDaily'
    yDateFormat = "MMM D"
  else if layout.chartType() == 'week'
    reportModel = 'Reports-AnalyticsWeekly'
    yDateFormat = "MMM D"
  else if layout.chartType() == 'month'
    reportModel = 'Reports-AnalyticsMonthly'
    yDateFormat = "MMM YYYY"

  fields    = [ 'visitors' ].join(',')
  startDate = layout.dateFrom()
  stopDate  = layout.dateTo()

  url = "/admin/#{reportModel}?f=#{fields}&where__report_date=$gte:#{ startDate },$lte:#{ stopDate }&o=report_date:asc&pp=40"

  $.get url, {}, (data) =>
    chartData = []
    _.each data, (row, i) ->
      chartData.push
        y: moment(row.report_date).format(yDateFormat)
        a: row.visitors

    layout.drawBarChart title, color, chartData