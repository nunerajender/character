#= require d3
#= require d3.vega
#= require_self
#= require ./_bars_chart

@Character.Dashboard ||= {}

#
# Marionette.js Router Documentation
# https://github.com/marionettejs/backbone.marionette/blob/master/docs/marionette.router.md
#
@Character.Dashboard.Router = Backbone.Marionette.AppRouter.extend
  initialize: (options) ->
    @appRoutes ||= {}
    @appRoutes["#{ options.path }(/:scope)"] = "index"

#
# Marionette.js Controller Documentation
# https://github.com/marionettejs/backbone.marionette/blob/master/docs/marionette.controller.md
#
@Character.Dashboard.Controller = Backbone.Marionette.Controller.extend
  initialize: ->
    @module = @options.module

  index: (scope, callback) ->
    chr.execute('showModule', @module)

    path = @options.moduleName + ( if scope then "/#{ scope }" else '' )
    if chr.currentPath != path
      chr.currentPath = path
      @module.layout.updateScope(scope, callback)
    else
      callback?()

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
                      <option value=signups>Sign-ups</option>
                    </select>

                    <div id=dashboard_visitors_chart class='dashboard-chart-visitors'></div>
                    <div id=dashboard_signups_chart class='dashboard-chart-signups' style='display:none;'></div>

                    <section class='dashboard-info'>
                      <div class='left'>
                        <header>Total User Accounts: <span id=dashboard_total_user_accounts></span>
                          <select id=dashboard_signups_select>
                            <option selected=true value=type>by Sign-up type</option>
                            <option value=country>by Country</option>
                          </select>
                        </header>
                        <div id=dashboard_signups_by_type class='dashboard-signups-by-type'>
                          <div class='row'><i class='fa fa-envelope'></i> Email<aside id=email_signups>0</aside></div>
                          <div class='row'><i class='fa fa-facebook'></i> Facebook<aside id=facebook_signups>0</aside></div>
                          <div class='row'><i class='fa fa-twitter'></i> Twitter<aside id=twitter_signups>0</aside></div>
                          <div class='row'><i class='fa fa-google-plus'></i> Google+<aside id=google_signups>0</aside></div>
                          <div class='row'>Never signed in<aside id=never_signed_in>0</aside></div>
                        </div>
                        <div id=dashboard_signups_by_country class='dashboard-signups-by-country' style='display:none;'>
                        </div>
                      </div>

                      <div class='right'>
                        <header>User Engagement</header>
                        <div id=dashboard_user_engagement></div>
                      </div>
                    </section>
                  </div>"""

  ui:
    view:                '#dashboard_view'
    users:               '#dashboard_users'
    predictions:         '#dashboard_predictions'
    completed:           '#dashboard_completed'
    empty:               '#dashboard_empty'
    facebook_signups:    '#facebook_signups'
    twitter_signups:     '#twitter_signups'
    google_signups:      '#google_signups'
    email_signups:       '#email_signups'
    never_signed_in:     '#never_signed_in'
    user_engagement:     '#dashboard_user_engagement'
    signups_select:      '#dashboard_signups_select'
    chart_select:        '#dashboard_chart_select'
    signups_by_type:     '#dashboard_signups_by_type'
    signups_by_country:  '#dashboard_signups_by_country'
    total_user_accounts: '#dashboard_total_user_accounts'
    signups_chart:       '#dashboard_signups_chart'
    visitors_chart:      '#dashboard_visitors_chart'

  # this doesn't work after back to dashboard from other module
  events:
    'change #dashboard_signups_select': '_changeSignupsView'

  onRender: ->
    # SIGNUPS INFO select
    @ui.signups_select.on 'change', (e) =>
      @ui.signups_by_type.hide()
      @ui.signups_by_country.hide()

      if $(e.currentTarget).val() == 'type'
        @ui.signups_by_type.show()
      else
        @ui.signups_by_country.show()

    # CHART select
    @ui.chart_select.on 'change', (e) =>
      @ui.signups_chart.hide()
      @ui.visitors_chart.hide()

      if $(e.currentTarget).val() == 'visitors'
        @ui.visitors_chart.show()
      else
        @ui.signups_chart.show()

  onClose: ->
    @ui.signups_select.off 'change'

  _updateCharts: ->
    # http://trifacta.github.io/vega/
    spec = Character.Dashboard.BarsChart
    spec.width  = @ui.view.width() - 140

    monthAgo    = moment().subtract('month', 1).format('YYYY-MM-DD')
    today       = moment().format('YYYY-MM-DD')
    reportModel = 'Reports-UsersDaily'
    fields      = [ 'report_date', 'singups', 'visitors' ].join(',')

    url = "/admin/#{reportModel}?f=#{fields}&where__report_date=$gte:#{ monthAgo },$lte:#{ today }&o=report_date:asc&pp=40"

    $.get url, {}, (data) =>
      # SIGNUPS chart
      spec.marks[0].properties.update.fill.value = '#78e7c8'
      spec.data[0].values = []
      _.each data, (row, i) -> spec.data[0].values.push { "x": moment(row.report_date).format("MMM D"), "y": row.singups }
      vg.parse.spec spec, (chart) -> chart({ el: "#dashboard_signups_chart" }).update()

      # VISITORS chart
      spec.marks[0].properties.update.fill.value = '#fac043'
      spec.data[0].values = []
      _.each data, (row, i) -> spec.data[0].values.push { "x": moment(row.report_date).format("MMM D"), "y": row.visitors }
      vg.parse.spec spec, (chart) -> chart({ el: "#dashboard_visitors_chart" }).update()

  _updateTotals: ->
    yesterday   = moment().subtract('day', 1).format('YYYY-MM-DD')
    today       = moment().format('YYYY-MM-DD')
    reportModel = 'Reports-UsersDaily'
    fields      = [ 'report_date',
                    'total_singups',
                    'total_facebook_signups',
                    'total_twitter_signups',
                    'total_google_signups',
                    'total_email_signups',
                    'total_never_signed_in',
                    'total_countries' ].join(',')

    url = "/admin/#{reportModel}?f=#{fields}&where__report_date=$gte:#{ yesterday },$lte:#{ today }&o=report_date:asc"

    $.get url, {}, (data) =>
      latestReport = _(data).last()

      # TOTALS
      @ui.total_user_accounts.html  latestReport.total_singups
      @ui.facebook_signups.html     latestReport.total_facebook_signups
      @ui.twitter_signups.html      latestReport.total_twitter_signups
      @ui.google_signups.html       latestReport.total_google_signups
      @ui.email_signups.html        latestReport.total_email_signups
      @ui.never_signed_in.html      latestReport.total_never_signed_in

      # COUNTRIES
      @ui.signups_by_country.html("")
      _.each latestReport.total_countries, (row) =>
        countryCode = row[0]
        usersNumber = row[1]
        countryName = Character.Dashboard.Countries[countryCode]
        if usersNumber > 0
          @ui.signups_by_country.append """<div class='row f32'>
                                             <i class='f32 flag #{countryCode}'></i>
                                             <span class='country-name'>#{countryName}</span>
                                             <aside>#{usersNumber}</aside>
                                           </div>"""

  _updateEngagement: ->
    reportModel = "Reports-UserEngagement"
    fields      = [ 'tournament_name',
                    'total_predictions',
                    'completed_predictions',
                    'uncompleted_predictions',
                    'users_without_predictions' ].join(',')

    url = "/admin/#{reportModel}?f=#{fields}&o=tournament_start_date:asc"

    $.get url, {}, (data) =>
      @ui.user_engagement.html("")
      _.each data, (r) =>
        @ui.user_engagement.append """
        <div class='row'><span class='title'>#{ r.tournament_name }</span>
          <div class='outline'>Total predictions: <aside>#{ r.total_predictions }</aside></div>
          <div class='outline'>Completed predictions: <aside>#{ r.completed_predictions }</aside></div>
          <div class='outline'>Uncompleted predictions: <aside>#{ r.uncompleted_predictions }</aside></div>
        </div>"""

  updateScope: (scope, callback) ->
    @_updateCharts()
    @_updateTotals()
    @_updateEngagement()

chr.dashboardModule = ->
  moduleName = 'dashboard'

  chr.module moduleName, (module) ->
    module = _(module).extend(Character.Dashboard)

    options =
      module:     module
      moduleName: moduleName

    module.on 'start', ->
      @controller = new @Controller(options)
      @layout     = new @Layout(options)
      @router     = new @Router({ path: moduleName, controller: @controller })
      chr.execute('addMenuItem', moduleName, 'bar-chart-o', 'Dashboard')