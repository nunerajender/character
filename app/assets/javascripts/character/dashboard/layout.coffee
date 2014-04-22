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
                    <div id=dashboard_chart class='dashboard-chart'></div>

                    <!--
                    <section class='dashboard-info'>
                      <div class='left'></div>
                      <div class='right'></div>
                    </section>
                    -->
                  </div>"""

  ui:
    view:        '#dashboard_view'
    chart:       '#dashboard_chart'
    chartSelect: '#dashboard_chart_select'

  events:
    'change #dashboard_chart_select': 'chartSelect'

  chartSelect: (e) ->
    chartName = @ui.chartSelect.val()
    Character.Dashboard.Charts[chartName](@ui)

  onRender: ->
     _.chain(Character.Dashboard.Charts).keys().each (key) =>
      title = _(key).capitalize()
      @ui.chartSelect.append("<option value=#{key}>#{title}</option>")

  updateScope: (chartName, callback) ->
    chartName ?= 'visitors'
    Character.Dashboard.Charts[chartName](@ui)