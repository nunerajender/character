#= require_self
#= require ./layout
#= require ./details

@Character.Settings ||= {}

#
# Marionette.js Module Documentation
# https://github.com/marionettejs/backbone.marionette/blob/master/docs/marionette.application.module.md
#
chr.module 'Settings', (module) ->
  module.addInitializer ->
    @layout     = new Character.Settings.Layout()
    @controller = new Character.Settings.Controller({ module: @ })
    @router     = new Character.Settings.Router({ controller: @controller })

#
# Marionette.js Router Documentation
# https://github.com/marionettejs/backbone.marionette/blob/master/docs/marionette.approuter.md
#
@Character.Settings.Router = Backbone.Marionette.AppRouter.extend
  appRoutes:
    'settings': 'index'
    'settings/:module_name': 'edit'

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

  edit: (module_name) ->
    @index()

    options = @module.submodules[module_name].options
    details_view = new options.detailsViewClass(options)

    @module.layout.details.show(details_view)
    @module.layout.setActiveMenuItem(module_name)

#
# Character Settings Module
# Initialize function
#
chr.settingsModule = (title, options={}) ->
  options.titleMenu     = title
  options.titleDetails ?= title
  options.moduleName   ?= _.underscored(title)

  options.detailsViewClass ?= Character.Settings.DetailsView

  chr.module "Settings.#{options.moduleName}", ->
    @options = options