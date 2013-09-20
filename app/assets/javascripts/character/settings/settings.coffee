#= require_self


@Character.module 'Settings', (Module, App) ->
  Module.Router = Backbone.Marionette.AppRouter.extend
    appRoutes:
      'settings':         'index'
      'settings/:module': 'edit'


  Module.Controller = Marionette.Controller.extend
    index: () ->
      console.log 'settings index'

    edit: (module) ->
      console.log 'settings edit'


  Module.addInitializer ->
    controller = new Module.Controller()
    router     = new Module.Router({ controller: controller })

    App.layout.menu.currentView.$el.find(' > a')
                                   .attr('href', '#/settings')
                                   .removeClass('browserid_logout')
                                   .html("<i class='icon-gears'></i> Settings")


  App.settings = (name, options={}) ->
    options.name = name
    options.path ?= _.slugify(name)

    @module "Settings.#{options.path}", ->
      @options = options