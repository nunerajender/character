class @CharacterLayout extends Backbone.Marionette.Layout
  template: JST['character/templates/main']
  regions:
    menu: "#menu"
    main: "#main"
  ui:
    title:           '#project_title'
    user_image:      '#user_image'
    top_menu:        '#menu .top-bar-section .left'
    first_menu_item: '#menu .top-bar-section .left li a:eq(0)'
    bottom_menu:     '#menu .top-bar-section .right'


  unselect_menu_item: ->
    if @selected_menu_item
      @selected_menu_item.removeClass 'active' 
      @selected_menu_item = no


  select_menu_item: (scope) ->
    @unselect_menu_item()
    # TODO: should be in ui
    link = $("#menu .top-bar-section li a[href='#/#{ scope }']:eq(0)")
    if link
      @selected_menu_item = link.parent()
      @selected_menu_item.addClass 'active'   







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

  onRender: ->
    @ui.title.html @options.title
    @ui.new_btn.attr 'href', "#/#{ @options.scope }/new"

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

  scope: ->
    @collection.scope

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

      # this allows to attach plugins when form is rendered
      $(document).trigger "character.#{ @scope() }.details.form.rendered", [ @el ]

  save_model: (obj) ->
    # when form is submitted but returns an error
    if typeof(obj) == 'string' then return @update_content(obj)
    # update model
    obj['__scope'] = @scope()
    if @model then @model.set(obj) else @collection.add(obj)

  on_delete: (e) ->
    if confirm("Do you really want to remove: '#{ @model.get('__title') }'?")
      @model.destroy()
      @close()
    else
      e.preventDefault() if e

  on_close: (e) ->
    @close()


