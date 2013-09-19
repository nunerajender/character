class @GenericLayout extends Backbone.Marionette.Layout
  template: (serialized_model) ->
    custom_template  = JST["#{ window.character_namespace }/templates/layout"]
    regular_template = JST["character/generic/templates/layout"]
    (custom_template || regular_template)(serialized_model)

  regions:
    header:  '#list_header'
    content: '#list_content'
    footer:  '#list_footer'
    details: '#details'

  ui:
    title:   '#list_title'
    scopes:  '#scopes'
    new_btn: '#action_new'
    details: '#details'


  update_title: (collection_scope) ->
    title = @options.title
    link  = "#/#{ @options.scope }"
    if collection_scope
      title = collection_scope.title
      link += "/#{ collection_scope.slug }"
    @ui.title.html title
    @ui.title.attr 'href', link


  onRender: ->
    @update_title()
    @ui.new_btn.attr 'href', "#/#{ @options.scope }/new"

    if @options.index_scopes
      @add_scope_control()

  add_scope_control: ->
    @ui.title.html 'All ' + @options.title
    @ui.title.addClass('dropdown').attr('data-dropdown', 'scopes')

    @ui.scopes.append """<li><a href='#/#{ @options.scope }'>All #{ @options.title }</a></li>"""

    _.each @options.index_scopes, (val, key) =>
      title  = _(key).titleize()
      title ?= val.title
      @ui.scopes.append """<li><a href='#/#{ @options.scope }/#{ key }'>#{ title }</a></li>"""


  # TODO: refactor this to work with CSS only
  show_logo: ->
    @ui.details.css { 'background-image': '' }


  # TODO: refactor this to work with CSS only
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