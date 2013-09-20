#= require ./layout
#= require ./collection


@AppController = Marionette.Controller.extend

  initialize: ->
    @options.collection = @initCollection()
    @layout = new AppLayout(@options)

  initCollection: ->
    collection = new AppCollection()
    collection.options = @options.collection_options
    return collection

  # actions ===============================================

  index: (scope, callback) ->
    @options.module.application.layout.content.show(@layout)
    @layout.header.update(scope)
    @options.collection.update(scope)

  new: (scope) ->

  edit: (scope, id) ->