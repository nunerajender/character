
#
# Backbone.js Model Documentation
# http://backbonejs.org/#Model
#
@Character.Generic.Model = Backbone.Model.extend
  idAttribute: '_id'

  urlRoot: ->
    @collection.options.collectionUrl

  getTitle: ->
    @get(@collection.options.titleField || _(@attributes).keys()[0])

  getMeta: ->
    @get(@collection.options.metaField)  || ''

  getThumb: ->
    @get(@collection.options.thumbField)

  getPosition: ->
    @get('_position')

  toJSON: (options={}) ->
    # add helpers for list item template
    object = _.clone(@attributes)

    object['__title'] = @getTitle()
    object['__meta']  = @getMeta()
    object['__thumb'] = @getThumb() || '#'

    return object


#
# Backbone.js Collection Documentation
# http://backbonejs.org/#Collection
#
@Character.Generic.Collection = Backbone.Collection.extend
  model: Character.Generic.Model

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
    params.q = @searchQuery
    params.o = @orderBy
    if @options.where
      [name, value] = @options.where.split('=')
      params["where__#{name}"] = value

    _.extend(params, @filter)
    _.extend(params, @options.constantParams)

    _.compactObject(params)

    @options.collectionUrl + "?" + $.param(params, true)


  setSearchQuery: (@searchQuery) ->
    return @


  setScope: (slug) ->
    @sortField     = null
    @sortDirection = null
    @orderBy       = null
    @filter        = {}

    scope = @options.scopes?[slug]

    @orderBy = scope?.order_by || @options.orderBy

    if @orderBy
      [ @sortField, @sortDirection ] = @orderBy.split(':')

    if scope
      [name, value] = scope.where.split('=')
      @filter["where__#{name}"] = value

    return @


  fetchPage: (@page, callback=false, reset=true, remove=true) ->
    @fetch
      reset: reset
      remove: remove
      success: (response) -> callback?(response)
      error: (collection, response, options) -> chr.execute('error', response)


  fetchNextPage: (callback) ->
    after_fetch = (response) => callback?()
    @fetchPage(@page + 1, after_fetch, false, false)


  # reverse sorting for backbone collection
  # http://stackoverflow.com/questions/5013819/reverse-sort-order-with-backbone-js


  comparator: (m) ->
    if @sortField
      return m.get(@sortField)


  sortBy: (iterator, context) ->
    # console.log @sortDirection
    # console.log @sortField

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