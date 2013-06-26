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

  onRender: ->
    console.log 'render collection'



class @CharacterAppIndexFormView extends Backbone.Marionette.ItemView
  template: JST["character/templates/form"]

  ui:
    header:  '#form_header'
    content: '#form_content'
    footer:  '#form_footer'

  events:
    'click #action_delete': 'on_delete'
    'click #action_close':  'on_close'

  # this method updates forms html and
  # then start all related plugins
  update_content: (html) ->
    @ui.content.html(html)
    
    @ui.content.find('form').addClass('custom')
    @ui.content.foundation('section', 'resize')
    @ui.content.foundation('forms', 'assemble')

  on_delete: (e) ->
    if confirm("Do you really want to remove: '#{ @model.get('title') }'?")
      #@model.destroy()
      @close()
    else
      e.preventDefault() if e

  on_close: (e) ->
    @close()


class @CharacterAppIndexLayout extends Backbone.Marionette.Layout
  template: JST["character/templates/list"]

  regions:
    header:  '#list_header'
    content: '#list_content'
    footer:  '#list_footer'
    details: '#details'

  onRender: ->
    console.log 'render layout'


