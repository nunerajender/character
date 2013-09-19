#= require ./app_controller
#= require ./app_router

class @GenericApp
  constructor: (name, opts={}) ->
    opts.name = name
    opts.pluralized_name        ?= _.pluralize(name)
    opts.path                   ?= _.slugify(opts.pluralized_name)
    opts.icon                   ?= 'bolt'
    opts.default_scope_order_by ?= {}
    opts.model_slug             ?= _.slugify(name)
    opts.reorderable            ?= false

    opts.scopes                 ?= {}
    _(opts.scopes).each (scope, slug) ->
      scope.slug  ||= slug
      scope.title ||= _(slug).titleize()

    opts.model_fields           ?= []
    opts.model_fields.push(opts.item_title)
    opts.model_fields.push(opts.item_meta)
    opts.model_fields.push(opts.item_image)
    opts.model_fields = _.compact(opts.model_fields)
    opts.model_fields = _.uniq(opts.model_fields)


    controller = new GenericAppController(opts)
    router     = new GenericAppRouter({ path: opts.path, controller: controller })

    character.module opts.name, ->
      @options    = opts
      # @controller = controller
      # @router     = router