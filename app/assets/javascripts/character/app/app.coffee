@Character.App ||= {}
@CharacterApp = (name, options={}) ->
  options.name ?= name
  options.pluralized_name ?= _.pluralize(options.name)
  options.path            ?= _.slugify(options.pluralized_name)
  options.icon            ?= 'bolt'
  options.implementation  ?= Character.App

  if options.scopes
    _(options.scopes).each (scope, slug) ->
      scope.slug  ||= slug
      scope.title ||= _(slug).titleize()

  options.model_fields ?= []
  options.model_fields.push(options.item_title)
  options.model_fields.push(options.item_meta)
  options.model_fields.push(options.item_image)
  options.model_fields = _.compact(options.model_fields)
  options.model_fields = _.uniq(options.model_fields)

  chr.module options.path, (app) =>

    app = _(app).extend(options.implementation)

    app.on 'start', =>
      app.collection = new app.Collection()
      app.collection.options =
        scopes:              options.scopes
        model_slug:          options.model_slug || _.slugify(name)
        order_by:            options.default_scope_order_by
        collection_url:      options.collection_url || "#{ chr.options.url }/#{ options.name }"
        item_title:          options.item_title
        item_meta:           options.item_meta
        item_image:          options.item_image
        reorderable:         options.reorderable || false
        constant_params:
          reorderable:       options.reorderable
          fields_to_include: options.model_fields.join(',')

      options.app = app

      app.controller = new app.Controller(options)
      app.main       = new app.MainView(options)
      app.router     = new app.Router({ path: options.path, controller: app.controller })

      chr.menu.addItem(options.path, options.icon, options.pluralized_name)