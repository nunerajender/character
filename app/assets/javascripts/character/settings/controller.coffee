
@Character.Settings ||= {}

#========================================================
# Controller
#========================================================
@Character.Settings.Controller = Marionette.Controller.extend
  initialize: ->
    @module = @options.module

  index: ->
    chr.path = 'settings'
    chr.menu.selectItem('settings')
    chr.main.show(@module.main)

  edit: (settings_app) ->
    @index()
    options      = @module.submodules[settings_app].options
    details_view = new options.detailsViewClass(options)

    @module.main.details.show(details_view)
    @module.main.setActiveMenuItem(settings_app)