#= require ./app_controller
#= require ./app_router

class @GenericApp
  constructor: (name, opts={}) ->
    opts.name = name
    opts.pluralized_name ?= _.pluralize(name)
    opts.path            ?= _.pluralize(_.slugify(name))
    opts.icon            ?= 'bolt'

    controller = new GenericAppController(opts)
    router     = new GenericAppRouter({ path: opts.path, controller: controller })

    character.module opts.name, ->
      @options    = opts
      # @controller = controller
      # @router     = router