#= require_self
#= require ./layout
#= require ./details
#= require ./_admins
#= require ./_categories
#= require ./_website
#= require ./_redirects
#= require ./_layout

# ---------------------------------------------------------
# SETTINGS
# ---------------------------------------------------------

@Character.Settings ||= {}

#
# Marionette.js Module Documentation
# https://github.com/marionettejs/backbone.marionette/blob/master/docs/marionette.application.module.md
#
chr.module 'settings', (module) ->
  module.addInitializer ->
    @layout     = new Character.Settings.Layout({ module: @ })
    @controller = new Character.Settings.Controller({ module: @ })
    @router     = new Character.Settings.Router({ controller: @controller })

#
# Marionette.js Router Documentation
# https://github.com/marionettejs/backbone.marionette/blob/master/docs/marionette.approuter.md
#
@Character.Settings.Router = Backbone.Marionette.AppRouter.extend
  appRoutes:
    'settings': 'index'
    'settings/:settingsModuleName': 'edit'

#
# Marionette.js Controller Documentation
# https://github.com/marionettejs/backbone.marionette/blob/master/docs/marionette.controller.md
#
@Character.Settings.Controller = Marionette.Controller.extend
  initialize: ->
    @module = @options.module

  index: ->
    @module.layout.details?.close()
    chr.execute('showModule', @module)
    chr.currentPath = "settings"
    @module.layout.unsetActiveMenuItem()

  edit: (settingsModuleName) ->
    @index()

    # this is required to work with generic details view
    options            = @module.submodules[settingsModuleName].options
    options.module     = @module.submodules[settingsModuleName]
    options.formUrl    = "#{ chr.options.url }/settings/#{ settingsModuleName }"
    options.fullscreen = false

    detailsView = new options.detailsViewClass(options)

    @module.layout.details.show(detailsView)
    @module.layout.setActiveMenuItem(settingsModuleName)

#
# Character Settings Module
# Initialize function
#
chr.settingsModule = (title, options={}) ->
  options.titleMenu    ?= title
  options.titleDetails ?= title
  options.moduleName   ?= _.underscored(title)

  options.detailsViewClass       ?= Character.Settings.DetailsLayout
  options.detailsHeaderViewClass ?= Character.Settings.DetailsHeaderView

  chr.module "settings.#{options.moduleName}", (module) ->
    module.DetailsHeaderView = options.detailsHeaderViewClass
    @options = options
