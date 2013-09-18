class @GenericController extends Marionette.Controller
  layout_class:       GenericLayout
  details_view_class: GenericDetailsView

  initialize: (@options) ->
    @api_url = @options.api || "/#{ window.character_namespace }/#{ @options.name }"

    # Collection setup
    @collection = new GenericCollection()

    collection_options =
      api:          @api_url
      scope:        @options.scope
      namespace:    @options.namespace
      order_by:     @options.index_default_scope_order_by || no
      reorderable:  @options.reorderable
      item_title:   @options.item_title
      item_meta:    @options.item_meta
      item_extra_fields: @options.item_extra_fields

    if @collection.options
      _(@collection.options).extend
    else
      @collection.options = collection_options

    @collection.set_sort_field()


  index: (collection_scope_name, callback) ->
    if @options.index_scopes and collection_scope_name
      collection_scope = @options.index_scopes[collection_scope_name]

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

      @layout = new @layout_class
        title:        @options.collection_title
        scope:        @options.scope
        index_scopes: @options.index_scopes

      @collection_view = new GenericCollectionView
        collection:   @collection
        reorderable:  @options.reorderable

      # This adds module scope class to the layout, to make css customization
      # possible and easy to do.

      @layout.$el.addClass "chr-scope-#{ @options.scope }"


      character.layout.main.show(@layout)

      @layout.show_logo()
      @layout.content.show(@collection_view)

      @collection.character_fetch(collection_scope, callback)

    else
      @layout.show_logo()
      @layout.unselect_item()
      @layout.update_title(collection_scope)

      # if collection scope has changed, update collection items
      if @collection.options.scope != collection_scope
        @collection.character_fetch(collection_scope, callback)
      else
        callback() if callback


  new: (collection_scope_name) ->
    @index collection_scope_name, =>
      @layout.hide_logo()
      details_view = new @details_view_class({ model: no, collection: @collection })
      @layout.details.show(details_view)

      $.get "#{ @api_url }/new", (html) =>
        details_view.update_content(html)


  edit: (collection_scope_name, id) ->
    @index collection_scope_name, =>
      @layout.hide_logo()
      @layout.select_item(id)

      doc = @collection.get(id)

      details_view = new @details_view_class({ model: doc, collection: @collection })
      @layout.details.show(details_view)

      $.get "#{ @api_url }/#{ id }/edit", (html) =>
        details_view.update_content(html)



