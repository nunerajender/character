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
#= require_self
#= require ./application

_.mixin(_.str.exports())

@CharacterOptions = {}

class @CharacterGenericModel extends Backbone.Model
  idAttribute: '_id'


class @CharacterGenericCollection extends Backbone.Collection
  model: window.CharacterGenericModel


@character = new Backbone.Marionette.Application()
@character.on "initialize:after", (options) ->
  # backbone history
  if Backbone.history then Backbone.history.start()
  
  # foundation plugins
  $(document).foundation('topbar section forms');

  console.log('Character: Let\'s rock!');

