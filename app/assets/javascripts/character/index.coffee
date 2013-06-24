#= require jquery
#= require jquery_ujs
#= require jquery.ui.sortable
#= require jquery.ui.datepicker
#= require underscore
#= require underscore.string
#= require underscore.inflection
#= require backbone
#= require backbone.marionette
#= require foundation
#= require_tree ./templates
#= require ./_model
#= require ./_views
#= require ./_application
#= require_self


_.mixin(_.str.exports())


@CharacterLayout = Backbone.Marionette.Layout.extend
  template: JST['character/templates/layout']
  regions:
    menu: "#menu"
    main: "#main"


@character = new Backbone.Marionette.Application()


@character.on "initialize:before", (options) ->
  @layout     = new CharacterLayout().render()
  $('body').html(@layout.el)


@character.on "initialize:after", (options) ->
  # application layout
  @layout     = new CharacterLayout()
  layout_html = @layout.render()
  $('body').html(layout_html.el)


  # backbone history
  if Backbone.history then Backbone.history.start()
  

  # foundation plugins
  $(document).foundation('topbar section forms');


  console.log('Character: Let\'s rock!');


new @CharacterApp("Project")
new @CharacterApp
  name: "Admin"
  api:  "/admin/api/Character-AdminUser"




