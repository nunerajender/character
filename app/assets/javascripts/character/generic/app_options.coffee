

class @GenericAppOptions
  constructor: (@name, options) ->
    _.extend(@, options)

    @pluralized_name        ?= _.pluralize(@name)
    @path                   ?= _.slugify(@pluralized_name)
    @icon                   ?= 'bolt'
    @model_slug             ?= _.slugify(@name)
    @reorderable            ?= false

    @scopes                 ?= {}
    _(@scopes).each (scope, slug) ->
      scope.slug  ||= slug
      scope.title ||= _(slug).titleize()

    @model_fields           ?= []
    @model_fields.push(@item_title)
    @model_fields.push(@item_meta)
    @model_fields.push(@item_image)
    @model_fields = _.compact(@model_fields)
    @model_fields = _.uniq(@model_fields)

    @collection_options =
      scopes:              @scopes
      order_by:            @default_scope_order_by
      collection_url:      @collection_url
      item_title:          @item_title
      item_meta:           @item_meta
      item_image:          @item_image
      constant_params:
        reorderable:       @reorderable
        fields_to_include: @model_fields.join(',')