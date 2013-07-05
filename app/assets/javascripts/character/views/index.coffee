class @CharacterAppIndexItemView extends Backbone.Marionette.ItemView
  template: JST["character/templates/list_item"]
  tagName: 'li'
  modelEvents:
    'change':  'render'
    'destroy': 'remove'



class @CharacterAppIndexNoItemsView extends Backbone.Marionette.ItemView
  template: JST["character/templates/list_empty"]



class @CharacterAppIndexCollectionView extends Backbone.Marionette.CollectionView
  tagName:   'ul'
  className: 'no-bullet'
  itemView:  CharacterAppIndexItemView
  emptyView: CharacterAppIndexNoItemsView



class @CharacterAppIndexLayout extends Backbone.Marionette.Layout
  template: JST["character/templates/list"]

  regions:
    header:  '#list_header'
    content: '#list_content'
    footer:  '#list_footer'
    details: '#details'

  ui:
    title:   '#list_title'
    new_btn: '#action_new'
    details: '#details'

  onRender: ->
    @ui.title.html @options.title
    @ui.new_btn.attr 'href', "#/#{ @options.scope }/new"

  show_logo: ->
    @ui.details.css { background: "#fff url(#{ window.company_logo_image_url }) no-repeat center center" }

  hide_logo: ->
    @ui.details.css { background: "#fff" }

  unselect_item: ->
    if @selected_item
      @selected_item.removeClass 'active'
      @selected_item = no

  select_item: (id) ->
    @unselect_item()
    # TODO: should be in ui
    link = $("#list_content li a[href='#/#{ @options.scope }/edit/#{ id }']:eq(0)")
    if link
      @selected_item = link.parent()
      @selected_item.addClass 'active'




