class @CharacterAppController extends Marionette.Controller
  initialize: (@options) ->
    @api_url = @options.api || "/admin/#{ @options.name }"
    
    # Collection setup
    @collection = new CharacterGenericCollection()
    
    collection_options = 
      api:        @api_url
      scope:      @options.scope
      order_by:   @options.index_scopes.default || no
    
    if @collection.options
      _(@collection.options).extend
    else
      @collection.options = collection_options

    @collection.set_sort_field()


  index: (callback) ->
    # this should also close details view if openned

    # if we are in the same scope don't re-render index
    if character.layout.scope != @options.scope

      character.layout.scope = @options.scope
      character.layout.select_menu_item(@options.scope)
      
      # NOTE: Layout and views were initiated in "initialize" method before,
      # but they are loosing events while navigation between apps, so after new
      # item is added to collection it's not rendered.

      # TODO: make sure that memory is still available after a couple of big
      # jumps between apps.
      
      @index_layout = new CharacterAppIndexLayout({ title: @options.collection_title, scope: @options.scope })
      @collection_view = new CharacterAppIndexCollectionView({ collection: @collection })

      # This adds module scope class to the layout, to make css customization
      # possible and easy to do.

      @index_layout.$el.addClass "chr-scope-#{ @options.scope }"
      
      character.layout.main.show(@index_layout)

      @index_layout.show_logo()
      @index_layout.content.show(@collection_view)

      @collection.character_fetch(callback)

    else
      @index_layout.show_logo()
      @index_layout.unselect_item()

      callback() if callback


  new: ->
    @index =>
      @index_layout.hide_logo()
      details_view = new CharacterAppDetailsView({ model: no, collection: @collection })
      @index_layout.details.show(details_view)

      $.get "#{ @api_url }/new", (html) => details_view.update_content(html)


  edit: (id) ->
    @index =>
      @index_layout.hide_logo()
      @index_layout.select_item(id)

      doc = @collection.get(id)

      details_view = new CharacterAppDetailsView({ model: doc, collection: @collection })
      @index_layout.details.show(details_view)

      $.get "#{ @api_url }/#{ id }/edit", (html) => details_view.update_content(html)



