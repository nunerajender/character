#= require_self
#= require ./app_router
#= require ./app_controller


@Character.Settings = {}


@character.addSettings = ->
  mod = @module 'Settings', (module, @application) ->
    controller = new Character.Settings.Controller()
    router     = new Character.Settings.Router({ controller: controller })

  mod.on 'start', ->
    @application.layout.menu.$el.find(' > a')
                                .attr('href', '#/settings')
                                .removeClass('browserid_logout')
                                .html("<i class='icon-gears'></i> Settings")


@character.settings = (name, options={}) ->
  if not @Settings then @addSettings()

  options.name = name
  options.path ?= _.slugify(name)

  @module "Settings.#{options.path}", ->
    @options = options