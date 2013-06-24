

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

    unless @index_view
      @index_view = new CharacterAppIndexView({ collection: @collection }).render()
    
    character.layout.main.show(@index_view)


  new: -> console.log "#{ @name } - new action."

  edit: -> console.log "#{ @name } - edit action."

  remove: -> console.log "#{ @name } - remove action."


class @CharacterAppIndexItemView extends Backbone.Marionette.ItemView
  template: JST["character/templates/index_item"]

class @CharacterAppIndexNoItemsView extends Backbone.Marionette.ItemView
  template: JST["character/templates/index_empty"]

class @CharacterAppIndexView extends Backbone.Marionette.CollectionView
  itemView:  CharacterAppIndexItemView
  emptyView: CharacterAppIndexNoItemsView




