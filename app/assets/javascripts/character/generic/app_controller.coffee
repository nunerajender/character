#= require ./app_layout
#= require ./collection

class @GenericAppController extends Marionette.Controller
  initialize: (@opts) ->
    @opts.collection = new GenericCollection()
    @opts.collection.options =
      item_title:     @opts.item_title
      item_meta:      @opts.item_meta
      item_image:     @opts.item_image
      reorderable:    @opts.reorderable
      model_fields:   @opts.model_fields
      collection_url: @opts.collection_url

    @layout          = new GenericAppLayout(@opts)

  index: (scope, callback) ->
    character.layout.content.show(@layout)
    @opts.collection.characterFetch()

  new: (scope) ->

  edit: (scope, id) ->