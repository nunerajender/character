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

                    <div id=dashboard_footer></div>
                  </div>"""

  regions:
    footer: '#dashboard_footer'

  ui:
    view:        '#dashboard_view'
    chart:       '#dashboard_chart'
    chartSelect: '#dashboard_chart_select'

  _selectChart: ->
    chartName = @ui.chartSelect.val()
    Character.Dashboard.Charts[chartName](@ui)

  onRender: ->
    _.chain(Character.Dashboard.Charts).keys().each (key) =>
      title = _(key).capitalize()
      @ui.chartSelect.append("<option value=#{key}>#{title}</option>")

    # TODO: after getting back to this layout from other app events declared in layout doesn't work
    # so doing this right here:
    @ui.chartSelect.on 'change', (e) => @_selectChart()

    @afterRenderContent?()

  onClose: ->
    @ui.chartSelect.off 'change'

    @afterOnClose?()


  updateScope: (chartName, callback) ->
    chartName ?= 'visitors'
    Character.Dashboard.Charts[chartName](@ui)