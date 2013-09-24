#= require ./collection
#= require ./layout

@Character.module 'App', (Module, App) ->

  #========================================================
  # Controller
  #========================================================
  Module.Controller = Backbone.Marionette.Controller.extend
    initialize: -> @app = @options.app

    index: (scope, callback) ->
      location.character = { path: @options.path, scope: scope }
      App.menu.selectItem(@options.path)
      App.main.show(@app.layout)
      @app.layout.header.update(scope)
      @app.collection.update(scope, callback)

    new: (scope) ->
      @index(scope)
      @app.layout.view.show(new Module.Layout.View({ model: no, name: @options.name, url: @options.collection_url }))

    edit: (scope, id) ->
      @index scope, =>
        doc = @app.collection.get(id)
        @app.layout.list.selectItem(id)
        @app.layout.view.show(new Module.Layout.View({ model: doc, name: @options.name, url: @options.collection_url }))


  #========================================================
  # Router
  #========================================================
  Module.Router = Backbone.Marionette.AppRouter.extend
    initialize: (options) ->
      @appRoutes = {}
      @appRoutes["#{ options.path }(/:scope)/new"]      = "new"
      @appRoutes["#{ options.path }(/:scope)/edit/:id"] = "edit"
      @appRoutes["#{ options.path }(/:scope)"]          = "index"


  #========================================================
  # Initialization
  #========================================================
  App.app = (name, options={}) ->
    options.name            ?= name
    options.model_slug      ?= _.slugify(options.name)
    options.pluralized_name ?= _.pluralize(options.name)
    options.path            ?= _.slugify(options.pluralized_name)
    options.icon            ?= 'bolt'
    options.reorderable     ?= false
    options.collection_url  ?= "/#{ options.name }"

    if options.scopes
      _(options.scopes).each (scope, slug) ->
        scope.slug  ||= slug
        scope.title ||= _(slug).titleize()

    options.model_fields ?= []
    options.model_fields.push(options.item_title)
    options.model_fields.push(options.item_meta)
    options.model_fields.push(options.item_image)
    options.model_fields = _.compact(options.model_fields)
    options.model_fields = _.uniq(options.model_fields)

    @module "App.#{ options.path }", (app) ->
      options.app = app

      app.collection = new Module.Collection()
      app.collection.options =
        scopes:              options.scopes
        order_by:            options.default_scope_order_by
        collection_url:      options.collection_url
        item_title:          options.item_title
        item_meta:           options.item_meta
        item_image:          options.item_image
        constant_params:
          reorderable:       options.reorderable
          fields_to_include: options.model_fields.join(',')

      controller = new Module.Controller(options)
      app.layout = new Module.Layout.Main(options)
      app.router = new Module.Router({ path: options.path, controller: controller })

      app.on 'start', -> App.menu.addItem(options.path, options.icon, options.pluralized_name)