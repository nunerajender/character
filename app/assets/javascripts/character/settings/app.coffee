

class @SettingsApp extends Backbone.Marionette.Application
  constructor: ->
    character.module 'Settings', (module) ->
      module.on 'start', ->
        routes =
          'settings':        'index'
          'settings/:scope': 'edit'

        AppRouter = Backbone.Marionette.AppRouter.extend
          appRoutes: routes

        #@controller = new SettingsController()
        #@router = new AppRouter
        #  controller: @controller