
class @CharacterApp
  constructor: (options_or_name) ->

    if typeof options_or_name == 'string'
      name    = options_or_name
      options = {} # generate defaults here
    else
      options = options_or_name
      name    = options.modelName
    
    if not name
      console.error('Model name is required to create CharacterApp instance.')
      return

    options.name = name

    @module = window.character.module name, ->
      @name  = options.name
      @scope = options.scope || _.pluralize(_.slugify(@name))

      routes = {}
      routes["#{ @scope }"]      = "index"
      routes["#{ @scope }/edit"] = "edit"

      AppRouter = Backbone.Marionette.AppRouter.extend
        appRoutes: routes

      AppController = 
        index: => console.log "#{ @name } index."
        edit:  => console.log "#{ @name } edit."

      @router = new AppRouter
        controller: AppController


new @CharacterApp("Project")
new @CharacterApp("Admin")

