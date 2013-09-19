#= require ./model

class @GenericCollection extends Backbone.Collection
  model: GenericModel


  url: ->
    params =
      reorderable: @options.reorderable

    if @options.collection_scope
      [name, value] = @options.collection_scope.where.split('=')
      params["where__#{name}"] = value
      params.order_by ?= @options.collection_scope.order_by

    # used default collections order_by if it is not set yet
    if not params.order_by
      params.order_by ?= @options.order_by

    params.scope       = @options.scope
    params.title_field = @options.item_title if @options.item_title
    params.meta_field  = @options.item_meta  if @options.item_meta

    unless _.isEmpty(@options.item_extra_fields)
      params["extra_fields[]"] = @options.item_extra_fields

    @options.api + "?" + $.param(params, true)


  character_fetch: (collection_scope, callback) ->
    @options.collection_scope = collection_scope
    @fetch
      reset: true
      success: (collection, response, options) =>
        # add scope to every model so it knows where it belongs
        collection.each (model) =>
          model.set
            __scope:            @options.scope
            __collection_scope: if collection_scope then collection_scope.slug || no else no
        callback() if callback


  # support of reverse sorting is taken from:
  # http://stackoverflow.com/questions/5013819/reverse-sort-order-with-backbone-js

  comparator: (m) ->
    if @options.order_by
      return m.get(@options.sort_field)

  set_sort_field: ->
    if @options.order_by
      params = @options.order_by.split(':')
      @options.sort_field     = params[0]
      @options.sort_direction = params[1]

  sortBy: (iterator, context) ->
    obj = @models
    direction = @options.sort_direction

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

  parse: (resp) ->
    @total_pages = parseInt(resp.total_pages)
    resp.objects