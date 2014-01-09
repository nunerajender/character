
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

  # Query parameters:
  #
  #   @page
  #   @search_query
  #   @order_by

  # Sort options:
  #
  #   @sortField
  #   @sortDirection

  url: (params={}) ->
    params.p = @page
    params.q = @search_query
    params.o = @order_by

    _.extend(params, @filter)
    _.extend(params, @options.constant_params)

    _.compactObject(params)

    @options.collection_url + "?" + $.param(params, true)


  setSearchQuery: (@search_query) ->
    return @


  setScope: (slug) ->
    @sortField     = null
    @sortDirection = null
    @order_by      = null
    @filter        = {}

    scope = @options.scopes?[slug]

    @order_by = scope?.order_by || @options.order_by

    if @order_by
      [ @sortField, @sortDirection ] = @order_by.split(':')

    if scope
      [name, value] = scope.where.split('=')
      @filter["where__#{name}"] = value

    return @


  fetchPage: (@page, callback=false, reset=true, remove=true) ->
    @fetch
      reset: reset
      remove: remove
      success: (response) -> callback?(response)
      error: (collection, response, options) -> Character.Plugins.showErrorModal(response)


  fetchNextPage: (callback) ->
    after_fetch = (response) => ( @page += 1 if response.length > 0 ) ; callback?()
    @fetchPage(@page + 1, after_fetch, false, false)


  # support of reverse sorting is taken from:
  # http://stackoverflow.com/questions/5013819/reverse-sort-order-with-backbone-js


  comparator: (m) ->
    if @sortField
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