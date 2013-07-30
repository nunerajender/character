

class @SettingsController extends Marionette.Controller
  index: ->
    character.layout.scope = 'settings'
    character.layout.select_menu_item('settings')

    @layout = new SettingsLayout()

    character.layout.main.show(@layout)
    @layout.show_logo()

    # auto redirect to first settings module
    if window.location.hash == '#/settings'
      @layout.jump_to_first_module()


  edit: (scope) ->
    if not @layout then @index()

    @layout.select_item(scope)
    @layout.hide_logo()

    module_options = character.submodules.Settings.submodules[scope].options

    details_view = new SettingsDetailsView(module_options)
    @layout.details.show(details_view)

    $.get "/admin/settings/#{scope}", (html) =>
      details_view.update_content(html)

