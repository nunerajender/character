@Character.App ||= {}
@CharacterApp = (name, options={}) ->
  options.name ?= name
  options.model_slug      ?= _.slugify(options.name)
  options.pluralized_name ?= _.pluralize(options.name)
  options.path            ?= _.slugify(options.pluralized_name)
  options.icon            ?= 'bolt'
  options.implementation  ?= Character.App
  options.search          ?= false
  options.reorder         ?= false
  options.items_per_page  ?= 25
  options.deletable       ?= true

  if options.scopes
    if options.scopes.default
      default_scope_order_by = options.scopes.default.order_by
      delete options.scopes['default']

    _(options.scopes).each (scope, slug) ->
      scope.slug  ||= slug
      scope.title ||= _(slug).titleize()

  default_scope_order_by ?= options.default_scope_order_by

  options.model_fields ?= []
  options.model_fields.push(options.item_title)
  options.model_fields.push(options.item_meta)
  options.model_fields.push(options.item_image)
  options.model_fields = _.compact(options.model_fields)
  options.model_fields = _.uniq(options.model_fields)

  chr.module options.path, (app) =>

    app = _(app).extend(options.implementation)

    app.on 'start', =>
      collection_url = options.collection_url || "#{ chr.options.url }/#{ options.name }"
      app.collection = new app.Collection()
      app.collection.options =
        collection_url:      collection_url
        scopes:              options.scopes
        model_slug:          options.model_slug
        order_by:            default_scope_order_by
        reorder:             options.reorder
        search:              options.search
        item_title:          options.item_title
        item_meta:           options.item_meta
        item_image:          options.item_image
        constant_params:
          f:  options.model_fields.join(',')
          pp: options.items_per_page

      options.app = app

      app.controller = new app.Controller(options)
      app.main       = new app.MainView(options)
      app.router     = new app.Router({ path: options.path, controller: app.controller })

      chr.menu.addItem(options.path, options.icon, options.pluralized_name)