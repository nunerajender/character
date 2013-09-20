

@AppModel = Backbone.Model.extend
  idAttribute: '_id'

  urlRoot: ->
    @collection.options.collection_url

  toJSON: (options={}) ->
    if options.process_for_save
      namespace = @collection.options.model_slug
      object    = {}
      object[namespace] = _.clone(@attributes)
    else
      object = _.clone(@attributes)

      # helpers for template
      object['__title'] = object[@collection.options.item_title]
      object['__meta']  = object[@collection.options.item_meta]
      object['__image'] = object[@collection.options.item_image] || ''
    return object