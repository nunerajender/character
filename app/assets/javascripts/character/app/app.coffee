#= require ./options
#= require ./controller
#= require ./router

@character.app = (name, opts={}) ->
  options    = new AppOptions(name, opts)
  controller = new AppController(options)
  router     = new AppRouter({ path: options.path, controller: controller })

  mod = @.module options.name, (module, @application) ->
    @options = options
    @options.module = module

  mod.on 'start', ->
    # register menu link for the app
    @application.layout.menu.add_item(options.path, options.icon, options.pluralized_name)