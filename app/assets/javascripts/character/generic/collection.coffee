#= require ./model

class @GenericCollection extends Backbone.Collection
  model: GenericModel

  parse: (resp) ->
    resp.objects

  url: (params) ->
    @options.collection_url + "?" + $.param(params || @requestParams || {}, true)

  update: (scope_slug, callback) ->
    scopes = @options.scopes
    params = {}

    if scope_slug and scopes
      scope  = scopes[scope_slug]

      if scope
        [name, value] = scope.where.split('=')
        params["where__#{name}"] = value
        params.order_by         ?= scope.order_by

    params.order_by ||= @options.order_by
    _.extend(params, @options.constant_params)

    if @url() != @url(params)
      @requestParams = params

      # update sorting options
      if @requestParams.order_by
        [ @sortField, @sortDirection ] = @requestParams.order_by.split(':')

      @fetch({ reset: true })

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