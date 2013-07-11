

class @SettingsController extends Marionette.Controller
  index: ->
    character.layout.scope = 'settings'
    character.layout.select_menu_item('settings')
    character.layout.main.close()


