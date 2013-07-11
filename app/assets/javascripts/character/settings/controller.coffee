

class @SettingsController extends Marionette.Controller
  index: ->
    character.layout.scope = 'settings'
    character.layout.select_menu_item('settings')

    @list_layout = new SettingsLayout

    character.layout.main.show(@list_layout)

