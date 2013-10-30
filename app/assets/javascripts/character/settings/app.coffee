

chr.module 'Settings', (Module, App) ->
  Module.addInitializer ->
    @main      = new Character.Settings.MainView()
    controller = new Character.Settings.Controller({ module: @ })
    router     = new Character.Settings.Router({ controller: controller })

    App.menu.$el.find(' > a')
            .attr('href', '#/settings')
            .addClass('mi-settings')
            .removeClass('browserid_logout')
            .html("<i class='fa fa-gears'></i> Settings")


@CharacterSettingsApp = (name, options={}) ->
  options.name = name
  options.path ?= _.slugify(name)

  chr.module "Settings.#{options.path}", -> @options = options