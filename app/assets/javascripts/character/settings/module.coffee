@Character.Settings ||= {}

#
# Marionette.js Module Documentation
# https://github.com/marionettejs/backbone.marionette/blob/master/docs/marionette.application.module.md
#
chr.module 'Settings', (Module, App) ->
  Module.addInitializer ->
    @layout    = new Character.Settings.Layout()
    controller = new Character.Settings.Controller({ module: @ })
    router     = new Character.Settings.Router({ controller: controller })

#
# Marionette.js Router Documentation
# https://github.com/marionettejs/backbone.marionette/blob/master/docs/marionette.approuter.md
#
@Character.Settings.Router = Backbone.Marionette.AppRouter.extend
  appRoutes:
    'settings':         'index'
    'settings/:module': 'edit'

#
# Marionette.js Controller Documentation
# https://github.com/marionettejs/backbone.marionette/blob/master/docs/marionette.controller.md
#
@Character.Settings.Controller = Marionette.Controller.extend
  initialize: ->
    @module = @options.module

  index: ->
    chr.path = 'settings'
    chr.execute('selectMenuItem',  'settings')
    chr.execute('showContentView', @module.layout)

  edit: (settings_app) ->
    @index()
    options      = @module.submodules[settings_app].options
    details_view = new options.detailsViewClass(options)

    @module.layout.details.show(details_view)
    @module.layout.setActiveMenuItem(settings_app)