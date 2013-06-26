class @CharacterAppController extends Marionette.Controller
  initialize: (@options) ->

    # Model api access url
    @api_url = @options.api || "/character/api/#{ @options.name }"
    
    # Collection setup
    @collection             = new CharacterGenericCollection()
    @collection.url         = @api_url
    @collection.model_name  = @options.name # this is used to identify if collection is already shown as index view

    # Layout and views
    @layout = new CharacterAppIndexLayout({ title: @options.collection_title })
    @collection_view = new CharacterAppIndexCollectionView({ collection: @collection })


  index: (callback) ->
    # this should also close details view if openned

    # if we are in the same scope don't re-render index
    if character.layout.scope != @options.scope

      character.layout.scope = @options.scope
      
      character.layout.main.show(@layout)
      @layout.content.show(@collection_view)

      @collection.fetch
        success: (collection, response, options) =>
          # add scope to every model so it knows where it belongs
          collection.each (model) => model.set({ __scope: @options.scope })

          console.log collection
          
          callback() if callback
    else
      callback() if callback


  new: ->
    @index =>
      details_view = new CharacterAppDetailsView({ model: no, collection: @collection })
      @layout.details.show(details_view)

      $.get "#{ @api_url }/new", (html) => details_view.update_content(html)


  edit: (id) ->
    @index =>
      doc = @collection.get(id)

      details_view = new CharacterAppDetailsView({ model: doc, collection: @collection })
      @layout.details.show(details_view)

      $.get "#{ @api_url }/#{ id }/edit", (html) => details_view.update_content(html)



