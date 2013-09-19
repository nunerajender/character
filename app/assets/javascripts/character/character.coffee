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

#= require ./character_application
#= require_self

_.mixin(_.str.exports())

@character = new CharacterApplication()
@character.on "initialize:before", (options) -> @render()
@character.on "initialize:after",  (options) -> @after()