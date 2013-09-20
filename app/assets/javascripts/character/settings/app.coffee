#= require_self
#= require ./router
#= require ./controller


@Character.settings = (name, options={}) ->
  if not @Settings
    mod = @module 'Settings', (module, @application) ->
      controller = new SettingsController()
      router     = new SettingsRouter({ controller: controller })

    mod.on 'start', ->
      @application.layout.menu.currentView.$el.find(' > a')
                                  .attr('href', '#/settings')
                                  .removeClass('browserid_logout')
                                  .html("<i class='icon-gears'></i> Settings")

  options.name = name
  options.path ?= _.slugify(name)

  @module "Settings.#{options.path}", ->
    @options = options