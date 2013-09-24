#= require jquery
#= require browserid
#= require jquery_ujs
#= require jquery.form
#= require underscore
#= require underscore.string
#= require underscore.inflection
#= require backbone
#= require backbone.marionette
#= require foundation
#= require moment
#= require ./plugins/reorderable
#= require ./plugins/date_field

#= require_self
#= require ./layout
#= require ./app/app


_.mixin(_.str.exports())

@Character = new Backbone.Marionette.Application()

@Character.on "initialize:after", ->
  Backbone.history.start() if Backbone.history

  location.hash = @menu.firstItem().attr('href') if location.hash == ""