

class @GenericModel extends Backbone.Model
  idAttribute: '_id'

  urlRoot: ->
    @collection.options.api

  toJSON: (options) ->
    if options and options.include_namespace
      obj = {}
      obj[@collection.options.namespace] = _.clone(this.attributes)
    else
      obj = _.clone(this.attributes)

    return obj