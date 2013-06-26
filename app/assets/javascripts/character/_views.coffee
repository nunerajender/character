class @CharacterAppIndexItemView extends Backbone.Marionette.ItemView
  template: JST["character/templates/list_item"]
  tagName: 'li'
  modelEvents:
    'change': 'render'


class @CharacterAppIndexNoItemsView extends Backbone.Marionette.ItemView
  template: JST["character/templates/list_empty"]



class @CharacterAppIndexCollectionView extends Backbone.Marionette.CollectionView
  tagName:   'ul'
  className: 'no-bullet'
  itemView:  CharacterAppIndexItemView
  emptyView: CharacterAppIndexNoItemsView

  onRender: ->
    console.log 'render collection'


class @CharacterAppIndexLayout extends Backbone.Marionette.Layout
  template: JST["character/templates/list"]

  regions:
    header:  '#list_header'
    content: '#list_content'
    footer:  '#list_footer'
    details: '#details'

  onRender: ->
    console.log 'render layout'



class @CharacterAppDetailsHeaderView extends Backbone.Marionette.ItemView
  template: JST["character/templates/details_header"]
  modelEvents:
    'change': 'render'


class @CharacterAppDetailsView extends Backbone.Marionette.Layout
  template: JST["character/templates/details"]

  regions:
    header:  '#details_header'

  ui:
    content: '#details_content'
    footer:  '#details_footer'

  events:
    'click #action_delete': 'on_delete'
    'click #action_close':  'on_close'

  # render header as view
  onRender: ->
    header_view = new CharacterAppDetailsHeaderView { model: @model }
    @header.show(header_view)

  # this method updates forms html and
  # then start all related plugins
  update_content: (html) ->
    @ui.content.html(html)

    @ui.form = @ui.content.find('form')
    
    if @ui.form
      @ui.form.addClass('custom')
      @ui.content.foundation('section', 'resize')
      @ui.content.foundation('forms', 'assemble')

      @ui.form.ajaxForm { success: (response) => @save_model(response) }

  save_model: (obj) ->
    # when form is submitted but returns an error
    if typeof(obj) == 'string' then return @update_content(obj)
    # update model
    if @model then @model.set(obj) else @collection.add(obj)

  on_delete: (e) ->
    if confirm("Do you really want to remove: '#{ @model.get('title') }'?")
      #@model.destroy()
      @close()
    else
      e.preventDefault() if e

  on_close: (e) ->
    @close()


