class @CharacterLayout extends Backbone.Marionette.Layout
  template: JST['character/templates/character']
  regions:
    menu: "#menu"
    main: "#main"
  ui:
    title:           '#project_title'
    user_image:      '#user_image'
    top_menu:        '#menu .top-bar-section .left'


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



