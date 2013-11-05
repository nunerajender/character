
@Character.App ||= {}

#========================================================
# Router
#========================================================
@Character.App.Router = Backbone.Marionette.AppRouter.extend
  initialize: (options) ->
    @appRoutes ||= {}
    @appRoutes["#{ options.path }(/:scope)/new"]      = "new"
    @appRoutes["#{ options.path }(/:scope)/edit/:id"] = "edit"
    @appRoutes["#{ options.path }(/:scope)"]          = "index"