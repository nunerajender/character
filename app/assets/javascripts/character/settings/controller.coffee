
@Character.Settings ||= {}

#========================================================
# Router
#========================================================
@Character.Settings.Router = Backbone.Marionette.AppRouter.extend
  appRoutes:
    'settings':         'index'
    'settings/:module': 'edit'


#========================================================
# Controller
#========================================================
@Character.Settings.Controller = Marionette.Controller.extend
  initialize: -> @module = @options.module

  index: ->
    chr.path = 'settings'
    chr.menu.selectItem('settings')
    chr.main.show(@module.main)

  edit: (settings_app) ->
    @index()
    details_view = new Character.Settings.DetailsView(@module.submodules[settings_app].options)
    @module.main.details.show(details_view)
    @module.main.setActiveMenuItem(settings_app)