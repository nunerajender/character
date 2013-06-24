
class @CharacterAppIndexItemView extends Backbone.Marionette.ItemView
  template: JST["character/templates/index_item"]
  tagName: 'li'


class @CharacterAppIndexNoItemsView extends Backbone.Marionette.ItemView
  template: JST["character/templates/index_empty"]


class @CharacterAppIndexCollectionView extends Backbone.Marionette.CollectionView
  tagName: 'ul'
  className: 'no-bullet'
  itemView:  CharacterAppIndexItemView
  emptyView: CharacterAppIndexNoItemsView


class @CharacterAppIndexLayout extends Backbone.Marionette.Layout
  template: JST["character/templates/index_layout"]
  className: 'chr-index-layout'

  regions:
    view_title:       '#index_title'
    view_collection:  '#index_collection'
    view_right:       '#right_panel'
