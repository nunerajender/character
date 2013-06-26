
class @CharacterGenericModel extends Backbone.Model
  idAttribute: '_id'


class @CharacterGenericCollection extends Backbone.Collection
  model: window.CharacterGenericModel

  parse: (resp) ->
    @total_pages = parseInt(resp.total_pages)
    resp.objects


  url_with_params: ->
    url     = @url
    params  = {}

    if _.keys(@request_params).length > 0
      params = _.map(@request_params, (value, key) -> if value then "#{ key }=#{ value }" )
      params = _.compact(params).join("&")
      url = "#{ url }?#{ params }"

    return url


  current_page: ->
    @request_params.page


  fetch_with_params: (options={}) ->
    options.url = @url_with_params() unless options.url
    @fetch(options)


  initialize: ->
    @total_pages = 0
    @request_params =
      page:         1
      per_page:     50
      search_query: ''




