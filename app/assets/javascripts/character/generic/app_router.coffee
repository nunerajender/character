

class @GenericAppRouter extends Backbone.Marionette.AppRouter
  initialize: (options) ->
    @appRoutes = {}
    @appRoutes["#{ options.path }(/:scope)/edit/:id"] = "edit"
    @appRoutes["#{ options.path }(/:scope)/new"]      = "new"
    @appRoutes["#{ options.path }(/:scope)"]          = "index"