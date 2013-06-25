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


class @CharacterAppIndexFormView extends Backbone.Marionette.ItemView
  template: JST["character/templates/form"]
  className: 'panel'

  ui:
    header: '#form_header'
    body:   '#form_body'
    footer: '#form_footer'


class @CharacterAppIndexLayout extends Backbone.Marionette.Layout
  template: JST["character/templates/index"]
  className: 'chr-index-layout'

  regions:
    header:      '#index_header'
    body:        '#index_body'
    footer:      '#index_footer'
    right_panel: '#right_panel'

  ui:
    right_panel: '#right_panel'


