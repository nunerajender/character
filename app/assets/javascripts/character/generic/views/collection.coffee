class @GenericCollectionItemView extends Backbone.Marionette.ItemView
  template: (serialized_model) =>
    custom_template  = JST["#{ window.character_namespace }/templates/#{ @model.collection.options.scope }/collection_item"]
    regular_template = JST["character/generic/templates/collection_item"]
    (custom_template || regular_template)(serialized_model)

  tagName: 'li'
  modelEvents:
    'change':  'render'
    'destroy': 'remove'

  onRender: ->
    @$el.attr 'data-id', @model.id
    @$el.attr 'data-position', @model.get('_position')


class @GenericCollectionEmptyView extends Backbone.Marionette.ItemView
  template: (serialized_model) ->
    custom_template  = JST["#{ window.character_namespace }/templates/collection_empty"]
    regular_template = JST["character/generic/templates/collection_empty"]
    (custom_template || regular_template)(serialized_model)


class @GenericCollectionView extends Backbone.Marionette.CollectionView
  tagName:   'ul'
  className: 'no-bullet'
  itemView:  GenericCollectionItemView
  emptyView: GenericCollectionEmptyView

  initialize: (options) ->
    @listenTo(@collection, 'sort', @render, @)

  onRender: ->
    if @options.reorderable then character_list.sortable(@$el, @collection)

