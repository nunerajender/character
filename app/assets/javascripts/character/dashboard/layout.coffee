#= require ./charts

#
# Marionette.js Layout Documentation
# https://github.com/marionettejs/backbone.marionette/blob/master/docs/marionette.layout.md
#
@Character.Dashboard.Layout = Backbone.Marionette.Layout.extend
  className: 'chr-module-generic'

  template: -> """<header class="chr-details-header"><div class="title">Dashboard</div></header>
                  <div id=dashboard_view class='dashboard-view'>

                    <select id=dashboard_chart_select class='dashboard-chart-select'>
                      <option selected=true value=visitors>Visitors</option>
                    </select>

                    <div id=dashboard_visitors_chart class='dashboard-chart-visitors'></div>

                    <!--<section class='dashboard-info'>
                      <div class='left'></div>
                      <div class='right'></div>
                    </section>-->
                  </div>"""

  ui:
    view:                '#dashboard_view'
    chart_select:        '#dashboard_chart_select'
    visitors_chart:      '#dashboard_visitors_chart'

  _updateCharts: ->
    spec = Character.Dashboard.BarsChart
    spec.width  = @ui.view.width() - 140

    monthAgo    = moment().subtract('month', 1).format('YYYY-MM-DD')
    today       = moment().format('YYYY-MM-DD')
    reportModel = 'Reports-AnalyticsDaily'
    fields      = [ 'visitors' ].join(',')

    url = "/admin/#{reportModel}?f=#{fields}&where__report_date=$gte:#{ monthAgo },$lte:#{ today }&o=report_date:asc&pp=40"

    $.get url, {}, (data) =>
      # VISITORS chart
      spec.marks[0].properties.update.fill.value = '#fac043'
      spec.data[0].values = []
      _.each data, (row, i) -> spec.data[0].values.push { "x": moment(row.report_date).format("MMM D"), "y": row.visitors }
      vg.parse.spec spec, (chart) -> chart({ el: "#dashboard_visitors_chart" }).update()

  updateScope: (scope, callback) ->
    @_updateCharts()