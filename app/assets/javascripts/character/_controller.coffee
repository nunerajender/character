class @CharacterAppController extends Marionette.Controller
  initialize: (@options) ->

    # Collection setup
    @collection     = new CharacterGenericCollection()
    @collection.url = @options.api || "/character/api/#{ @options.name }"

    @layout = new CharacterAppIndexLayout()
    @collection_view = new CharacterAppIndexCollectionView({ collection: @collection })


  index: ->
    character.layout.main.show(@layout)
    @layout.body.show(@collection_view)

    @collection.fetch()
    
    # Header
    #@layout.header.show(@options.name)

    # Add pagination
    # Add saving last state
    # Add search
    # Add scopes
    # Add batch actions


  new: ->
    @index()
    @layout.ui.right_panel.show()


  edit: ->
    console.log "#{ @options.name } - edit action."


  remove: ->
    console.log "#{ @options.name } - remove action."



