class @SettingsLayout extends Backbone.Marionette.Layout
  template: JST["character/settings/templates/layout"]

  regions:
    header:  '#list_header'
    content: '#list_content'
    footer:  '#list_footer'
    details: '#details'

  ui:
    user_email:     '#user_email'
    details:        '#details'
    settings_menu:  '#settings_menu'


  add_menu_item: (name, scope) ->
    @ui.settings_menu.append """<li><a href='#/settings/#{scope}' title='#{name}'>#{name}</a></li>"""


  onRender: ->
    @update_user_email()

    _.each character.Settings.submodules, (m) =>
      name  = m.options.name
      scope = m.options.scope
      @add_menu_item(name, scope)


  show_logo: ->
    @ui.details.css { 'background-image': '' }


  hide_logo: ->
    @ui.details.css { 'background-image': 'none' }


  unselect_item: ->
    if @selected_item
      @selected_item.removeClass 'active'
      @selected_item = no


  select_item: (scope) ->
    @unselect_item()
    # TODO: should be in ui
    link = $("#settings_menu li a[href='#/settings/#{ scope }']:eq(0)")
    if link
      @selected_item = link.parent()
      @selected_item.addClass 'active'


  update_user_email: ->
    @ui.user_email.html(window.user_email)


  jump_to_first_module: ->
    path = $("#settings_menu li a:eq(0)").attr 'href'
    window.location.hash = path



