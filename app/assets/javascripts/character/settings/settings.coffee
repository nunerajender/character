#= require ./layout

@Character.module 'Settings', (Module, App) ->

  #========================================================
  # Router
  #========================================================
  Module.Router = Backbone.Marionette.AppRouter.extend
    appRoutes:
      'settings':         'index'
      'settings/:module': 'edit'

  #========================================================
  # Controller
  #========================================================
  Module.Controller = Marionette.Controller.extend
    initialize: -> @app = @options.app

    index: ->
      App.main.show(@app.layout)

    edit: (module) ->
      @index()
      console.log 'settings edit'

  #========================================================
  # Initialization
  #========================================================
  Module.addInitializer ->
    @layout    = new Module.Layout.Main()
    controller = new Module.Controller({ app: @ })
    router     = new Module.Router({ controller: controller })

    App.layout.menu.currentView.$el.find(' > a')
                                   .attr('href', '#/settings')
                                   .removeClass('browserid_logout')
                                   .html("<i class='icon-gears'></i> Settings")

  App.settings = (name, options={}) ->
    options.name = name
    options.path ?= _.slugify(name)

    @module "Settings.#{options.path}", -> @options = options