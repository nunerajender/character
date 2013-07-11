class @GenericCollectionItemView extends Backbone.Marionette.ItemView
  template: JST["character/generic/templates/collection_item"]
  tagName: 'li'
  modelEvents:
    'change':  'render'
    'destroy': 'remove'

  onRender: ->
    @$el.attr 'data-id', @model.id
    @$el.attr 'data-position', @model.get('_position')


class @GenericCollectionEmptyView extends Backbone.Marionette.ItemView
  template: JST["character/generic/templates/collection_empty"]


class @GenericCollectionView extends Backbone.Marionette.CollectionView
  tagName:   'ul'
  className: 'no-bullet'
  itemView:  GenericCollectionItemView
  emptyView: GenericCollectionEmptyView

  initialize: (options) ->
    @listenTo(@collection, 'sort', @render, @)

  onRender: ->
    if @options.reorderable then character_list.sortable(@$el, @collection)

