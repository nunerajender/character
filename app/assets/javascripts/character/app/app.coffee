#= require ./options
#= require ./collection
#= require ./layout

@Character.module 'App', (Module, App) ->
  Module.Router = Backbone.Marionette.AppRouter.extend
    initialize: (options) ->
      @appRoutes = {}
      @appRoutes["#{ options.path }(/:scope)/edit/:id"] = "edit"
      @appRoutes["#{ options.path }(/:scope)/new"]      = "new"
      @appRoutes["#{ options.path }(/:scope)"]          = "index"


  Module.Controller = Marionette.Controller.extend

    initialize: ->
      @options.collection = @initCollection()
      @layout = new AppLayout(@options)

    initCollection: ->
      collection = new AppCollection()
      collection.options = @options.collection_options
      return collection

    # actions ===============================================

    index: (scope, callback) ->
      App.layout.content.show(@layout)
      @layout.header.update(scope)
      @options.collection.update(scope)

    new: (scope) ->

    edit: (scope, id) ->


  App.app = (name, opts={}) ->
    options    = new AppOptions(name, opts)
    controller = new Module.Controller(options)
    router     = new Module.Router({ path: options.path, controller: controller })

    app = @module "App.#{ options.name }", -> @options = options
    app.on 'start', -> App.add_menu_item(options.path, options.icon, options.pluralized_name)