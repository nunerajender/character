class @GenericLayout extends Backbone.Marionette.Layout
  template: JST["character/generic/templates/layout"]

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

