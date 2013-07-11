#= require jquery
#= require browserid
#= require jquery_ujs
#= require jquery.form
#= require simple_form.date
#= require underscore
#= require underscore.string
#= require underscore.inflection
#= require backbone
#= require backbone.marionette
#= require foundation
#= require character_list.sortable

#= require ./base/application
#= require ./generic/application
#= require ./settings/application

#= require_self


_.mixin(_.str.exports())


@character = new Character()
@character.settings = new Settings()


@character.on "initialize:before", (options) ->
  @render()


@character.on "initialize:after", (options) ->
  # backbone history
  if Backbone.history then Backbone.history.start()
  
  @initialize_plugins()
  @update_user_image()
  @add_menu_items()
  @jump_to_first_app()

  console.log('Character: Let\'s rock!')