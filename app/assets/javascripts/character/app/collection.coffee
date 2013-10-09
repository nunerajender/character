
@Character.App ||= {}

#========================================================
# Model
#========================================================
@Character.App.Model = Backbone.Model.extend
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
      object['__title'] = @getTitle()
      object['__meta']  = @getMeta()
      object['__image'] = @getImage() || ''
    return object

  getTitle:    -> @get(@collection.options.item_title || _(@attributes).keys()[0])
  getMeta:     -> @get(@collection.options.item_meta) || ''
  getImage:    -> @get(@collection.options.item_image)
  getPosition: -> @get('_position')


#========================================================
# Collection
#========================================================
@Character.App.Collection = Backbone.Collection.extend
  model: Character.App.Model

  # parse: (resp) ->
  #   resp.objects

  url: (params) ->
    @options.collection_url + "?" + $.param(params || @requestParams || {}, true)

  updateRequestParams: (scope_slug) ->
    scopes = @options.scopes
    params = {}

    # slug
    if scope_slug and scopes
      scope  = scopes[scope_slug]

      if scope
        [name, value] = scope.where.split('=')
        params["where__#{name}"] = value
        params.order_by         ?= scope.order_by

    # sort order
    params.order_by ||= @options.order_by

    _.extend(params, @options.constant_params)

    if @url() != @url(params)
      @requestParams = params

      # update sorting options
      if @requestParams.order_by
        [ @sortField, @sortDirection ] = @requestParams.order_by.split(':')

      return true
    else
      return false

  update: (scope_slug, callback) ->
    paramsChanged = @updateRequestParams(scope_slug)

    if paramsChanged
      @fetch({ reset: true, success: -> callback?() })
    else
      callback?()

  # support of reverse sorting is taken from:
  # http://stackoverflow.com/questions/5013819/reverse-sort-order-with-backbone-js

  comparator: (m) ->
    if @requestParams.order_by
      return m.get(@sortField)

  sortBy: (iterator, context) ->
    obj = @models
    direction = @sortDirection

    return _.pluck( _.map(obj, ( (value, index, list) ->
      return {
        value:    value
        index:    index
        criteria: iterator.call(context, value, index, list)
      }
    ) ).sort( ( (left, right) ->
       # swap a and b for reverse sort
       a = if direction is "asc" then left.criteria else right.criteria
       b = if direction is "asc" then right.criteria else left.criteria

       if a != b
         if a > b or a is undefined then return 1
         if a < b or b is undefined then return -1

       return (if left.index < right.index then -1 else 1)
    ) ), 'value' )