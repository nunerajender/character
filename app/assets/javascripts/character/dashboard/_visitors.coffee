#= require ./bar

@Character.Dashboard.Charts ||= {}
@Character.Dashboard.Charts.visitors = (layout) ->
  ui = layout.ui
  ui.chart.attr('data-title', 'Visitors')

  spec = Character.Dashboard.Bar
  spec.width  = ui.view.width() - 140

  startDate = layout.dateFrom()
  stopDate  = layout.dateTo()

  if layout.chartType() == 'day'
    reportModel = 'Reports-AnalyticsDaily'
    yDateFormat = "MMM D"
  else if layout.chartType() == 'week'
    reportModel = 'Reports-AnalyticsWeekly'
    yDateFormat = "MMM D"
  else if layout.chartType() == 'month'
    reportModel = 'Reports-AnalyticsMonthly'
    yDateFormat = "MMM YY"

  fields      = [ 'visitors' ].join(',')

  url = "/admin/#{reportModel}?f=#{fields}&where__report_date=$gte:#{ startDate },$lte:#{ stopDate }&o=report_date:asc&pp=40"

  $.get url, {}, (data) =>
    spec.marks[0].properties.update.fill.value = '#fac043'
    spec.data[0].values = []
    _.each data, (row, i) -> spec.data[0].values.push { "x": moment(row.report_date).format(yDateFormat), "y": row.visitors }
    vg.parse.spec spec, (chart) -> chart({ el: "#dashboard_chart" }).update()