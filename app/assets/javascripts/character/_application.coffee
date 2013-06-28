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
      console.error 'Model name is required to create CharacterApp instance.' ; return

    if not options.pluralized_name then options.pluralized_name = _.pluralize(name)

    if not options.scope then options.scope = _.pluralize(_.slugify(name))

    if not options.collection_title then options.collection_title = _(name).pluralize()

    if not options.icon then options.icon = 'bolt'

    character.module name, ->
      @options = options
      
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

