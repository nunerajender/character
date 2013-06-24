
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
      routes["#{ scope }"]      = "index"
      routes["#{ scope }/new"]  = "new"
      routes["#{ scope }/edit"] = "edit"

      AppRouter = Backbone.Marionette.AppRouter.extend
        appRoutes: routes

      @controller = options.controller || new CharacterAppController(options)
      @router = new AppRouter
        controller: @controller


class @CharacterAppController extends Marionette.Controller
  initialize: (@options) ->
    @name = @options.name

    # Collection setup
    @collection     = new CharacterGenericCollection()
    @collection.url = @options.api || "/admin/api/#{ @options.name }"


  index: ->
    @collection.fetch()

    @layout = new CharacterAppIndexLayout().render()
    character.layout.main.show(@layout)

    @collection_view = new CharacterAppIndexCollectionView({ collection: @collection }).render()
    #@layout.title.show(@option.name)
    @layout.view_collection.show(@collection_view)


  new: -> console.log "#{ @name } - new action."

  edit: -> console.log "#{ @name } - edit action."

  remove: -> console.log "#{ @name } - remove action."



