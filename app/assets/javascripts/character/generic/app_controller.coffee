#= require ./app_layout

class @GenericAppController extends Marionette.Controller
  initialize: (@options) ->
    @layout     = new GenericAppLayout(@options)
    @collection = [] #new GenericCollection()

  index: (scope, callback) ->
    character.layout.content.show(@layout)

  new: (scope) ->

  edit: (scope, id) ->