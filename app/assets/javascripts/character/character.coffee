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

#= require_self
#= require ./character_layout
#= require ./app/app
#= require ./settings/app

_.mixin(_.str.exports())

@Character = new Backbone.Marionette.Application()

@Character.on "initialize:after", ->
  Backbone.history.start() if Backbone.history

  # jump to the first app in list on first load
  location.hash = @layout.menu.ui.items.find('a').attr('href') if location.hash == ""