#= require ./_visitors

#
# Marionette.js Layout Documentation
# https://github.com/marionettejs/backbone.marionette/blob/master/docs/marionette.layout.md
#
@Character.Dashboard.Layout = Backbone.Marionette.Layout.extend
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
                    <div id=dashboard_chart class='dashboard-chart'></div>
                    <div id=dashboard_footer></div>
                  </div>"""

  regions:
    footer: '#dashboard_footer'

  ui:
    view:        '#dashboard_view'
    chart:       '#dashboard_chart'
    chartSelect: '#dashboard_chart_select'
    dateFrom:    '#dashboard_chart_date_from'
    dateTo:      '#dashboard_chart_date_to'
    typeSelect:  '#dashboard_chart_type_select'

  _renderChart: ->
    Character.Dashboard.Charts[@chartName](@)

  chartType: -> @ui.typeSelect.val()
  dateFrom: -> @ui.dateFrom.val()
  dateTo: -> @ui.dateTo.val()

  setDateRange: (fromDate, toDate) ->
    fromDate ?= moment().subtract('month', 1).format('YYYY-MM-DD')
    toDate   ?= moment().format('YYYY-MM-DD')

    @ui.dateFrom.val(fromDate)
    @ui.dateTo.val(toDate)

  _selectChart: ->
    @chartName = @ui.chartSelect.val()
    @_renderChart()

  _selectDate: ->
    @_renderChart()

  _selectType: ->
    @_renderChart()

  onRender: ->
    _.chain(Character.Dashboard.Charts).keys().each (key) =>
      title = _(key).capitalize()
      @ui.chartSelect.append("<option value=#{key}>#{title}</option>")

    # TODO: after getting back to this layout from other app events declared in layout doesn't work
    # so doing this right here:
    @ui.chartSelect.on 'change', (e) => @_selectChart()
    @ui.typeSelect.on 'change', (e) => @_selectType()
    @ui.dateFrom.on 'change', (e) => @_selectDate()
    @ui.dateTo.on 'change', (e) => @_selectDate()

    @afterRenderContent?()

  onClose: ->
    @ui.chartSelect.off 'change'
    @ui.typeSelect.off 'change'
    @ui.dateFrom.off 'change'
    @ui.dateTo.off 'change'

    @afterOnClose?()

  updateScope: (@chartName, callback) ->
    @chartName ?= 'visitors'
    @_renderChart()