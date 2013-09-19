#= require_tree ./templates
#= require_tree ./views
#= require ./controller
#= require ./model
#= require ./collection
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

    # Index list default scope sort order
    options.index_default_scope_order_by ?= {}

    # Index scopes options with labels
    if options.index_scopes
      _(options.index_scopes).each (val, key) ->
        val.slug  ||= key
        val.title ||= _(key).titleize()

    # Extra model fields for custom template, if needed
    options.item_extra_fields ?= []

    # Reordering items in a list
    options.reorderable       ?= false

    # Namespace which is used in rails update method, used to save models
    options.namespace         ?= _.slugify(name)

    @initialize_character_module(options)

  # When adding custom views new routes may be required,
  # if so this method should be overriden.
  routes: (app_scope) ->
    routes = {}
    # Order is important here: new should be before index
    # to have collection_scopes work correct.
    routes["#{ app_scope }(/:collection_scope_name)/edit/:id"] = "edit"
    routes["#{ app_scope }(/:collection_scope_name)/new"]      = "new"
    routes["#{ app_scope }(/:collection_scope_name)"]          = "index"
    routes


  initialize_character_module: (options) ->
    routes     = @routes(options.scope)
    controller = new @controller_class(options)

    character.module options.name, ->
      @options    = options
      @controller = controller
      AppRouter   = Backbone.Marionette.AppRouter.extend({ appRoutes: routes })
      @router     = new AppRouter({ controller: controller })