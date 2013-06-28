#= require jquery
#= require jquery_ujs
#= require jquery.ui.sortable
#= require jquery.ui.datepicker
#= require jquery.form
#= require underscore
#= require underscore.string
#= require underscore.inflection
#= require backbone
#= require backbone.marionette
#= require foundation
#= require_tree ./templates
#= require ./_model
#= require ./_views
#= require ./_controller
#= require ./_application
#= require_self


_.mixin(_.str.exports())


@CharacterLayout = Backbone.Marionette.Layout.extend
  template: JST['character/templates/main']
  regions:
    menu: "#menu"
    main: "#main"
  ui:
    title:      '#project_title'
    user_image: '#user_image'


@character = new Backbone.Marionette.Application()


@character.on "initialize:before", (options) ->

  # render main layout
  @layout = new CharacterLayout().render()
  $('body').html(@layout.el)


@character.on "initialize:after", (options) ->

  # backbone history
  if Backbone.history then Backbone.history.start()
  
  # foundation plugins
  $(document).foundation('topbar section forms');

  # update external values defined in html layout
  #@layout.ui.title.html(window.website_name)
  @layout.ui.user_image.attr( 'src', window.user_image_url)

  # jump to the first item in the menu
  if window.location.hash == "" 
    path = $('#menu .top-bar-section .left li a:eq(0)').attr 'href'
    window.location.hash = path

  console.log('Character: Let\'s rock!');


new @CharacterApp("Project")
new @CharacterApp
  name: "Admin"
  api:  "/admin/Character-AdminUser"




