class @GenericListItemView extends Backbone.Marionette.ItemView
  template: JST["character/templates/generic/list_item"]
  tagName: 'li'
  modelEvents:
    'change':  'render'
    'destroy': 'remove'

  onRender: ->
    @$el.attr 'data-id', @model.id
    @$el.attr 'data-position', @model.get('_position')


class @GenericListNoItemsView extends Backbone.Marionette.ItemView
  template: JST["character/templates/generic/list_empty"]



class @GenericListCollectionView extends Backbone.Marionette.CollectionView
  tagName:   'ul'
  className: 'no-bullet'
  itemView:  GenericListItemView
  emptyView: GenericListNoItemsView

  initialize: (options) ->
    @listenTo(@collection, 'sort', @render, @)

  onRender: ->
    if @options.reorderable then character_list.sortable(@$el, @collection)



class @GenericListLayout extends Backbone.Marionette.Layout
  template: JST["character/templates/generic/list"]

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
    @ui.details.css { 'background-image': '' }

  hide_logo: ->
    @ui.details.css { 'background-image': 'none' }

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




