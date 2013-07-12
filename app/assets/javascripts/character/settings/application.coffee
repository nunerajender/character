#= require_tree ./templates
#= require_tree ./views
#= require ./controller
#= require_self


class @SettingsApplication
  constructor: (name, options={}) ->
    options.name = name

    # Character module scope which is used in urls
    options.scope ?= _.pluralize(_.slugify(name))

    character.module "Settings.#{name}", ->
      @options = options


class @Settings extends Backbone.Marionette.Application
  constructor: ->
    character.module 'Settings', (module) ->
      module.on 'start', ->
        routes = {}
        routes['settings'] = 'index'

        _.each @submodules, (m) ->
          routes["settings/#{ m.options.scope }"] = "edit"

        AppRouter = Backbone.Marionette.AppRouter.extend
          appRoutes: routes

        @controller = new SettingsController()
        @router = new AppRouter
          controller: @controller

