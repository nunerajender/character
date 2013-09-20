#= require ./app_options
#= require ./app_controller
#= require ./app_router

class @GenericApp
  constructor: (name, opts={}) ->
    options    = new GenericAppOptions(name, opts)
    controller = new GenericAppController(options)
    router     = new GenericAppRouter({ path: options.path, controller: controller })

    character.module options.name, ->
      @options = options