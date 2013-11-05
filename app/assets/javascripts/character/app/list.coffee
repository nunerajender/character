@Character.App ||= {}
@Character.App.ListView = Backbone.Marionette.CollectionView.extend
  tagName: 'ul'

  initialize: ->
    @itemView  = @options.app.ListItemView
    @emptyView = @options.app.ListEmtpyView

    @listenTo(@collection, 'sort', @render, @)

  onRender: ->
    @selectItem(@selected_item_id) if @selected_item_id
    if @collection.options.reorder then Character.Plugins.reorderable(@$el, @collection)

  selectItem: (id) ->
    @selected_item_id = id
    @$el.find('li.active').removeClass('active')
    @$el.find("li[data-id=#{ id }]").addClass('active')

  unselectCurrentItem: ->
    @selected_item_id = null
    @$el.find('li.active').removeClass('active')