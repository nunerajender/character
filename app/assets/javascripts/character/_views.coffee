class @CharacterAppIndexItemView extends Backbone.Marionette.ItemView
  template: JST["character/templates/index_item"]
  tagName: 'li'


class @CharacterAppIndexNoItemsView extends Backbone.Marionette.ItemView
  template: JST["character/templates/index_empty"]


class @CharacterAppIndexCollectionView extends Backbone.Marionette.CollectionView
  tagName:   'ul'
  className: 'no-bullet'
  itemView:  CharacterAppIndexItemView
  emptyView: CharacterAppIndexNoItemsView


class @CharacterAppIndexLayout extends Backbone.Marionette.Layout
  template: JST["character/templates/index"]
  className: 'chr-index-layout'

  regions:
    header:     '#index_header'
    body:       '#index_body'
    footer:     '#index_footer'
    view_right: '#right_panel'

  ui:
    right_panel: '#right_panel'


