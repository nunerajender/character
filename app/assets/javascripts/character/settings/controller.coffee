

class @SettingsController extends Marionette.Controller
  index: ->
    character.layout.scope = 'settings'
    character.layout.select_menu_item('settings')

    @layout = new SettingsLayout(models: [ {one: 1}, {one: 2}, { one: 3} ])

    character.layout.main.show(@layout)


  edit: ->
    ;