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
#= require ./character_application
#= require ./app/app
#= require ./settings/app

_.mixin(_.str.exports())

@Character = {}