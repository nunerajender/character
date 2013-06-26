class @CharacterAppController extends Marionette.Controller
  initialize: (@options) ->

    # Model api access url
    @api_url = @options.api || "/character/api/#{ @options.name }"
    
    # Collection setup
    @collection             = new CharacterGenericCollection()
    @collection.url         = @api_url
    @collection.model_name  = @options.name # this is used to identify if collection is already shown as index view

    # Layout and views
    @layout = new CharacterAppIndexLayout()
    @collection_view = new CharacterAppIndexCollectionView({ collection: @collection })


  index: (callback) ->
    # this should also close details view if openned

    # if we are in the same scope don't re-render index
    if character.layout.scope != @options.scope

      character.layout.scope = @options.scope
      
      character.layout.main.show(@layout)
      @layout.content.show(@collection_view)

      @collection.fetch
        success: =>
          callback() if callback
    else
      callback() if callback

    # Header
    #@layout.header.show(@options.name)

    # Add pagination
    # Add saving last state
    # Add search
    # Add scopes
    # Add batch actions


  new: ->
    @index =>
      form = new CharacterAppIndexFormView({ model: no })
      @layout.details.show(form)

      $.get "#{ @api_url }/new", (html) => form.update_content(html)


  edit: (id) ->
    @index =>
      doc = @collection.get(id)

      form = new CharacterAppIndexFormView({ model: doc })
      @layout.details.show(form)

      $.get "#{ @api_url }/#{ id }/edit", (html) => form.update_content(html)


  remove: ->
    console.log "#{ @options.name } - remove action."



