#= require ./list_item


@AppListEmtpy = Backbone.Marionette.ItemView.extend
  template: -> """<div class='empty'>No items found</div>"""


@AppList = Backbone.Marionette.CollectionView.extend
  tagName:   'ul'
  itemView:  AppListItem
  emptyView: AppListEmtpy

  #initialize: (options) ->
    #@listenTo(@collection, 'sort', @render, @)

  # onRender: ->
  #   if @options.reorderable then character_list.sortable(@$el, @collection)