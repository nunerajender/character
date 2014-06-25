#= require ./_visitors

#
# Marionette.js Layout Documentation
# https://github.com/marionettejs/backbone.marionette/blob/master/docs/marionette.layout.md
#
@Character.Dashboard.Layout = Backbone.Marionette.LayoutView.extend
  className: 'chr-module-generic'

  template: -> """<header class="chr-details-header"><div class="title">Dashboard</div></header>
                  <div id=dashboard_view class='dashboard-view'>
                    <select id=dashboard_chart_select class='dashboard-chart-select'></select>
                    <aside class='dashboard-chart-options'>
                      <select id=dashboard_chart_type_select>
                        <option value=day>Day</option>
                        <option value=week>Week</option>
                        <option value=month>Month</option>
                      </select>
                      <input type=date id=dashboard_chart_date_from />
                      —
                      <input type=date id=dashboard_chart_date_to />
                    </aside>
                    <div id=dashboard_chart_wrapper class='dashboard-chart-wrapper'>
                      <div id=dashboard_chart></div>
                    </div>
                    <div id=dashboard_footer></div>
                  </div>"""

  regions:
    footer: '#dashboard_footer'

  ui:
    view:         '#dashboard_view'
    chart:        '#dashboard_chart'
    chartWrapper: '#dashboard_chart_wrapper'
    chartSelect:  '#dashboard_chart_select'
    typeSelect:   '#dashboard_chart_type_select'
    dateFrom:     '#dashboard_chart_date_from'
    dateTo:       '#dashboard_chart_date_to'

  _renderChart: ->
    Character.Dashboard.Charts[@chartName](@)

  _selectChart: ->
    @chartName = @ui.chartSelect.val()
    @_renderChart()

  chartType: -> @ui.typeSelect.val()
  dateFrom: -> @ui.dateFrom.val()
  dateTo: -> @ui.dateTo.val()

  setDateRange: (fromDate, toDate) ->
    fromDate ?= moment().subtract('month', 1).format('YYYY-MM-DD')
    toDate   ?= moment().format('YYYY-MM-DD')

    @ui.dateFrom.val(fromDate)
    @ui.dateTo.val(toDate)

  _selectDateFrom: ->
    fromDate = @dateFrom()

    if @chartType() == 'day'
      toDate = moment(fromDate).add('month', 1).format('YYYY-MM-DD')
    else if @chartType() == 'week'
      toDate = moment(fromDate).add('weeks', 30).format('YYYY-MM-DD')
    else if @chartType() == 'month'
      toDate = moment(fromDate).add('months', 30).format('YYYY-MM-DD')

    @setDateRange(fromDate, toDate)
    @_renderChart()

  _selectDateTo: ->
    toDate = @dateTo()

    if @chartType() == 'day'
      fromDate = moment(toDate).subtract('month', 1).format('YYYY-MM-DD')
    else if @chartType() == 'week'
      fromDate = moment(toDate).subtract('weeks', 30).format('YYYY-MM-DD')
    else if @chartType() == 'month'
      fromDate = moment(toDate).subtract('months', 30).format('YYYY-MM-DD')

    @setDateRange(fromDate, toDate)
    @_renderChart()

  _selectType: -> @_selectDateTo()

  onRender: ->
    @currentChartType = ''

    _.chain(Character.Dashboard.Charts).keys().each (key) =>
      title = _(key).capitalize()
      @ui.chartSelect.append("<option value=#{key}>#{title}</option>")

    # TODO: after getting back to this layout from other app events declared in layout doesn't work
    # so doing this right here:
    @ui.chartSelect.on 'change', (e) => @_selectChart()
    @ui.typeSelect.on 'change', (e) => @_selectType()
    @ui.dateFrom.on 'change', (e) => @_selectDateFrom()
    @ui.dateTo.on 'change', (e) => @_selectDateTo()

    @afterRenderContent?()

  onDestroy: ->
    # NOTE: seems to be never called in current implementation
    @ui.chartSelect.off 'change'
    @ui.typeSelect.off 'change'
    @ui.dateFrom.off 'change'
    @ui.dateTo.off 'change'

    @afterOnClose?()

  updateScope: (@chartName, callback) ->
    @chartName ?= 'visitors'
    @_renderChart()

  setChartTitle: (title) ->
    @ui.chartWrapper.attr('data-title', title)

  resetCurrentChart: ->
    @ui.chart.html('')
    @currentChart = null
    @currentChartType = ''

  drawBarChart: (title, color, data) ->
    if data.length > 0
      if @currentChartType == 'bar'
        @currentChart.options.colors = [ color ]
        @currentChart.options.labels = [ title ]
        @currentChart.setData data
      else
        @resetCurrentChart()

        options =
          element:         'dashboard_chart'
          data:            data
          barColors:       [ color ]
          labels:          [ title ]
          xkey:            'y'
          ykeys:           [ 'a' ]
          # styles
          hideHover:       true
          gridTextFamily:  'sans-serif'
          gridTextColor:   '#a9b1b5'
          gridTextSize:    11
          barOpacity:      0.6
          barSizeRatio:    0.97
          numLines:        6
          gridStrokeWidth: 0.1

        # https://github.com/morrisjs/morris.js
        @currentChart = Morris.Bar options

        @setChartTitle(title)
        @currentChartType = 'bar'
    else
      @setChartTitle('No data')