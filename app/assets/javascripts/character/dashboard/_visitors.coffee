#= require ./bar

@Character.Dashboard.Charts ||= {}
@Character.Dashboard.Charts.visitors = (ui) ->
  ui.chart.attr('data-title', 'Visitors')

  spec = Character.Dashboard.Bar
  spec.width  = ui.view.width() - 140

  monthAgo    = moment().subtract('month', 1).format('YYYY-MM-DD')
  today       = moment().format('YYYY-MM-DD')
  reportModel = 'Reports-AnalyticsDaily'
  fields      = [ 'visitors' ].join(',')

  url = "/admin/#{reportModel}?f=#{fields}&where__report_date=$gte:#{ monthAgo },$lte:#{ today }&o=report_date:asc&pp=40"

  $.get url, {}, (data) =>
    spec.marks[0].properties.update.fill.value = '#fac043'
    spec.data[0].values = []
    _.each data, (row, i) -> spec.data[0].values.push { "x": moment(row.report_date).format("MMM D"), "y": row.visitors }
    vg.parse.spec spec, (chart) -> chart({ el: "#dashboard_chart" }).update()