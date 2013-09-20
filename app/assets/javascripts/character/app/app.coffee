#= require ./options
#= require ./collection
#= require ./list
#= require ./list_header

@Character.module 'App', (Module, App) ->
  Module.Router = Backbone.Marionette.AppRouter.extend
    initialize: (options) ->
      @appRoutes = {}
      @appRoutes["#{ options.path }(/:scope)/edit/:id"] = "edit"
      @appRoutes["#{ options.path }(/:scope)/new"]      = "new"
      @appRoutes["#{ options.path }(/:scope)"]          = "index"


  Module.Controller = Marionette.Controller.extend
    initialize: ->
      @layout = new Module.Layout(@options)

    index: (scope, callback) ->
      App.main.show(@layout)
      @layout.header.update(scope)
      @options.collection.update(scope)

    new: (scope) ->

    edit: (scope, id) ->


  Module.Layout = Backbone.Marionette.Layout.extend
    className: 'chr-app-layout'

    template: -> """<div class='left-panel'>
                      <div id='list_header' class='chr-app-list-header'></div>
                      <div id='list_content' class='chr-app-list'></div>
                    </div>
                    <aside class='right-panel logo' id='logo'></aside>"""

    regions:
      list_header:  '#list_header'
      list_content: '#list_content'

    onRender: ->
      @header = new AppListHeader(@options)
      @list   = new AppList({ collection: @options.collection })

      @list_header.show(@header)
      @list_content.show(@list)


  App.app = (name, options={}) ->
    @module "App.#{ name }", (app) ->
      options = new AppOptions(name, options)

      options.collection         = new Module.Collection()
      options.collection.options = options.collection_options

      controller        = new Module.Controller(options)
      controller.router = new Module.Router({ path: options.path, controller: controller })

      app.on 'start', -> App.add_menu_item(options.path, options.icon, options.pluralized_name)