#= require ./app_layout
#= require ./collection

class @GenericAppController extends Marionette.Controller

  initialize: (@opts) ->
    @opts.collection = @initCollection()
    @layout = new GenericAppLayout(@opts)

  initCollection: ->
    collection = new GenericCollection()
    collection.options = @opts.collection_options
    return collection

  # actions ===============================================

  index: (scope, callback) ->
    character.layout.content.show(@layout)
    @opts.collection.update(scope)

  new: (scope) ->

  edit: (scope, id) ->