class @CharacterApp
  constructor: (options_or_name) ->

    if typeof options_or_name == 'string'
      name    = options_or_name
      options = {} # generate defaults here
      options.name = name
    else
      options = options_or_name
      name    = options.name if options
    
    if not name
      console.error 'Model name is required to create CharacterApp instance.'
      return

    if not options.scope then options.scope = _.pluralize(_.slugify(name))

    # Add module to the main application
    window.character.module name, ->
      scope  = options.scope
      routes = {}
      routes["#{ scope }"]          = "index"
      routes["#{ scope }/new"]      = "new"
      routes["#{ scope }/edit/:id"] = "edit"

      AppRouter = Backbone.Marionette.AppRouter.extend
        appRoutes: routes

      @controller = options.controller || new CharacterAppController(options)
      @router = new AppRouter
        controller: @controller

