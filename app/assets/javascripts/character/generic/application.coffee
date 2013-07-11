#= require_tree ./templates
#= require_tree ./views
#= require ./controller
#= require ./model
#= require_self


class @GenericApplication
  constructor: (name, options={}) ->
    options.name = name

    # Pluralized name for model to be used in default templates
    options.pluralized_name   ?= _.pluralize(name)

    # Character module scope which is used in urls
    options.scope             ?= _.pluralize(_.slugify(name))

    # Title to be shown in index list header
    options.collection_title  ?= _(name).pluralize()

    # Default icon to be used in character menu for the module
    options.icon              ?= 'bolt'

    # Sorting options for index list
    options.index_scopes      ?= {}

    # Reordering items in a list
    options.reorderable       ?= false

    # Namespace which is used in rails update method, used to save models
    options.namespace         ?= _.slugify(name)


    character.module name, ->
      @options = options
      
      scope  = options.scope
      routes = {}
      routes["#{ scope }"]          = "index"
      routes["#{ scope }/new"]      = "new"
      routes["#{ scope }/edit/:id"] = "edit"

      AppRouter = Backbone.Marionette.AppRouter.extend
        appRoutes: routes

      @controller = options.controller || new GenericController(options)
      @router = new AppRouter
        controller: @controller

