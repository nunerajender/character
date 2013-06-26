class @CharacterAppIndexItemView extends Backbone.Marionette.ItemView
  template: JST["character/templates/list_item"]
  tagName: 'li'


class @CharacterAppIndexNoItemsView extends Backbone.Marionette.ItemView
  template: JST["character/templates/list_empty"]


class @CharacterAppIndexCollectionView extends Backbone.Marionette.CollectionView
  tagName:   'ul'
  className: 'no-bullet'
  itemView:  CharacterAppIndexItemView
  emptyView: CharacterAppIndexNoItemsView


class @CharacterAppIndexFormView extends Backbone.Marionette.ItemView
  template: JST["character/templates/form"]

  ui:
    header:  '#form_header'
    content: '#form_content'
    footer:  '#form_footer'


class @CharacterAppIndexLayout extends Backbone.Marionette.Layout
  template: JST["character/templates/list"]

  regions:
    header:  '#list_header'
    content: '#list_content'
    footer:  '#list_footer'
    details: '#details'


