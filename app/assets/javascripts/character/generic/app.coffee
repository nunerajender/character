#= require ./controller
#= require ./router

class @GenericApp
  constructor: (name, opts={}) ->
    opts.name = name
    opts.pluralized_name ?= _.pluralize(name)
    opts.path            ?= _.pluralize(_.slugify(name))
    opts.icon            ?= 'bolt'

    controller = new GenericController(opts)
    router     = new GenericRouter({ options: opts, controller: controller })

    character.module opts.name, ->
      @options    = opts
      @controller = controller
      @router     = router