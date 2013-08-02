#= require_tree ./templates
#= require_tree ./views
#= require ./controller
#= require ./model
#= require_self


class @GenericApplication
  # Controller class is set as an option to make it easy
  # to expand generic application with custom views.
  controller_class: GenericController

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

    @initialize_character_module(options)

  # When adding custom views new routes may be required
  # so this method should be overriden.
  routes: (scope) ->
    routes = {}
    routes["#{ scope }"]          = "index"
    routes["#{ scope }/new"]      = "new"
    routes["#{ scope }/edit/:id"] = "edit"
    routes


  initialize_character_module: (options) ->
    routes     = @routes(options.scope)
    controller = new @controller_class(options)

    character.module options.name, ->
      @options    = options
      @controller = controller
      AppRouter   = Backbone.Marionette.AppRouter.extend({ appRoutes: routes })
      @router     = new AppRouter({ controller: controller })


