class @GenericController extends Marionette.Controller
  initialize: (@options) ->
    @api_url = @options.api || "/admin/#{ @options.name }"
    
    # Collection setup
    @collection = new GenericCollection()
    
    collection_options = 
      api:          @api_url
      scope:        @options.scope
      namespace:    @options.namespace
      order_by:     @options.index_scopes.default || no
      reorderable:  @options.reorderable
      item_title:   @options.item_title
      item_meta:    @options.item_meta
    
    if @collection.options
      _(@collection.options).extend
    else
      @collection.options = collection_options

    @collection.set_sort_field()


  index: (callback) ->
    # this should also close details view if openned

    # if we are in the same module scope -> don't re-render index
    if character.layout.scope != @options.scope

      character.layout.scope = @options.scope
      character.layout.select_menu_item(@options.scope)
      
      # NOTE: Layout and views were initiated in "initialize" method before,
      # but they are loosing events while navigation between apps, so after new
      # item is added to collection it's not rendered.

      # TODO: make sure that memory is still available after a couple of big
      # jumps between apps.
      
      @list_layout = new GenericListLayout
        title:        @options.collection_title
        scope:        @options.scope

      @collection_view = new GenericListCollectionView
        collection:   @collection
        reorderable:  @options.reorderable

      # This adds module scope class to the layout, to make css customization
      # possible and easy to do.

      @list_layout.$el.addClass "chr-scope-#{ @options.scope }"
      

      character.layout.main.show(@list_layout)

      @list_layout.show_logo()
      @list_layout.content.show(@collection_view)

      @collection.character_fetch(callback)

    else
      @list_layout.show_logo()
      @list_layout.unselect_item()

      callback() if callback


  new: ->
    @index =>
      @list_layout.hide_logo()
      details_view = new GenericDetailsView({ model: no, collection: @collection })
      @list_layout.details.show(details_view)

      $.get "#{ @api_url }/new", (html) => details_view.update_content(html)


  edit: (id) ->
    @index =>
      @list_layout.hide_logo()
      @list_layout.select_item(id)

      doc = @collection.get(id)

      details_view = new GenericDetailsView({ model: doc, collection: @collection })
      @list_layout.details.show(details_view)

      $.get "#{ @api_url }/#{ id }/edit", (html) => details_view.update_content(html)


