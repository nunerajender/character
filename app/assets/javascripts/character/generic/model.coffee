


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



class @GenericCollection extends Backbone.Collection
  model: GenericModel


  url: ->
    params =
      reorderable: @options.reorderable

    params.order_by    = @options.order_by   if @options.order_by
    params.title_field = @options.item_title if @options.item_title
    params.meta_field  = @options.item_meta  if @options.item_meta
    unless _.isEmpty(@options.index_extra_fields)
      params["extra_fields[]"] = @options.index_extra_fields

    @options.api + "?" + $.param(params, true)


  character_fetch: (callback) ->
    @fetch
      reset: true
      success: (collection, response, options) =>
        # add scope to every model so it knows where it belongs
        collection.each (model) => model.set({ __scope: @options.scope })
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


  # initialize: ->
  #   @total_pages = 0
  #   @request_params =
  #     page:         1
  #     per_page:     50
  #     search_query: ''

  # current_page: ->
  #   @request_params.page

  # url_with_params: ->
  #   url     = @url
  #   params  = {}

  #   if _.keys(@request_params).length > 0
  #     params = _.map(@request_params, (value, key) -> if value then "#{ key }=#{ value }" )
  #     params = _.compact(params).join("&")
  #     url = "#{ url }?#{ params }"

  #   return url



