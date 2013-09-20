

@SettingsRouter = Backbone.Marionette.AppRouter.extend
  appRoutes:
    'settings':         'index'
    'settings/:module': 'edit'