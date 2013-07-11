

class @Settings
  constructor: ->
    character.module 'Settings', ->
      routes = {}
      routes['settings'] = 'index'

      AppRouter = Backbone.Marionette.AppRouter.extend
        appRoutes: routes

      @controller = new SettingsController()
      @router = new AppRouter
        controller: @controller

