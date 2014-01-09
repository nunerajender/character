@Character.App ||= {}
@Character.App.ListView = Backbone.Marionette.CollectionView.extend
  tagName: 'ul'

  initialize: ->
    @itemView  = @options.app.ListItemView
    @emptyView = @options.app.ListEmtpyView

    @listenTo(@collection, 'sort', @render, @)


  loadMoreItems: ->
    # NOTE: This still will request a new page every time if last item is last on last page
    if @collection.size() == @collection.page * @collection.options.constant_params.pp
      if not @loading_more_items_in_progress
        @loading_more_items_in_progress = true
        @collection.fetchNextPage =>
          @loading_more_items_in_progress = false


  onRender: ->
    @$el.parent().scroll (e) =>
      if e.target.offsetHeight + e.target.scrollTop + 272 > @$el.height()
        @loadMoreItems()

    @selectItem(@selected_item_id) if @selected_item_id
    if @collection.options.reorder then Character.Plugins.reorderable(@$el, @collection)


  selectItem: (id) ->
    @selected_item_id = id
    @$el.find('li.active').removeClass('active')
    @$el.find("li[data-id=#{ id }]").addClass('active')


  unselectCurrentItem: ->
    @selected_item_id = null
    @$el.find('li.active').removeClass('active')