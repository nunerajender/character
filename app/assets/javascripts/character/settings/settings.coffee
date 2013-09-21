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

      @app.layout.setActiveMenuItem(module)
      @app.layout.view.show(new Module.Layout.View())

      $.get "/admin/settings/#{ module }", (html) =>
        @app.layout.view.currentView.ui.form.html(html)


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

    @module "Settings.Apps.#{options.path}", -> @options = options