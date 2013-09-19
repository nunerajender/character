#= require ./list_item

class @GenericListEmtpy extends Backbone.Marionette.ItemView
  template: -> """<div class='empty'>No items found</div>"""


class @GenericList extends Backbone.Marionette.CollectionView
  tagName:   'ul'
  itemView:  GenericListItem
  emptyView: GenericListEmtpy

  #initialize: (options) ->
    #@listenTo(@collection, 'sort', @render, @)

  # onRender: ->
  #   if @options.reorderable then character_list.sortable(@$el, @collection)