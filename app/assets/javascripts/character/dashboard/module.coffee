#= require d3
#= require d3.vega
#= require_self
#= require ./layout

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