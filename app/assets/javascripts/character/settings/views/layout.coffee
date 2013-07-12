class @SettingsLayout extends Backbone.Marionette.Layout
  template: JST["character/settings/templates/layout"]

  regions:
    header:  '#list_header'
    content: '#list_content'
    footer:  '#list_footer'
    details: '#details'

  ui:
    details:        '#details'
    settings_menu:  '#settings_menu'

  add_menu_item: (name, scope) ->
    @ui.settings_menu.append """<li><a href='#/settings/#{scope}' title='#{name}'>#{name}</a></li>"""

  onRender: ->
    _.each character.Settings.submodules, (m) =>
      name  = m.moduleName
      scope = _.slugify(name)
      @add_menu_item(name, scope)

  show_logo: ->
    @ui.details.css { 'background-image': '' }

  hide_logo: ->
    @ui.details.css { 'background-image': 'none' }

