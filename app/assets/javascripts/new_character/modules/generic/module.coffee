#= require_self
#= require ./model
#= require ./layout

@Character.Generic ||= {}

#
# Marionette.js Router Documentation
# https://github.com/marionettejs/backbone.marionette/blob/master/docs/marionette.router.md
#
@Character.Generic.Router = Backbone.Marionette.AppRouter.extend
  initialize: (options) ->
    @appRoutes ||= {}
    @appRoutes["#{ options.path }(/:listScope)/new"]      = "new"
    @appRoutes["#{ options.path }(/:listScope)/edit/:id"] = "edit"
    @appRoutes["#{ options.path }(/:listScope)"]          = "index"

#
# Marionette.js Controller Documentation
# https://github.com/marionettejs/backbone.marionette/blob/master/docs/marionette.controller.md
#
@Character.Generic.Controller = Backbone.Marionette.Controller.extend
  initialize: ->
    @module     = @options.module
    @collection = @module.collection

  index: (listScope, callback) ->
    chr.execute('showModule', @module)

    @module.layout.header.update(listScope)
    @collection.setScope(listScope).fetchPage(1, callback)

    # current_path = "#{ @options.path }" + ( if scope then "/#{ scope }" else '')
    # if chr.path != current_path
    #   chr.path = current_path
    #   chr.menu.selectItem(@options.path)
    #   chr.main.show(@module.layout)
    #   @module.layout.header.update(scope)

    #   @module.collection.setScope(scope).fetchPage(1, callback)
    # else
    #   @module.layout.list.unselectCurrentItem()
    #   @module.layout.details.close()
    #   callback?()

  new: (listScope) ->
  #   @index(scope)
  #   view = new @module.DetailsView
  #     model:      no
  #     name:       @options.name
  #     url:        @module.collection.options.collection_url + "/new"
  #     collection: @module.collection
  #     app:        @module
  #   @module.main.details.show(view)

  edit: (listScope, id) ->
  #   @index scope, =>
  #     doc = @module.collection.get(id)
  #     @module.main.list.selectItem(id)
  #     view = new @module.DetailsView
  #       model:      doc
  #       name:       @options.name
  #       url:        @module.collection.options.collection_url + "/#{ id }/edit"
  #       collection: @module.collection
  #       app:        @module
  #       deletable:  @options.deletable
  #     @app.main.details.show(view)

#
# Character Generic Module
# Initialize function
#

chr.genericModule = (name, options={}) ->
  options.menuTitle ?= name
  options.menuIcon  ?= 'bolt'

  options.listTitle        ?= _.pluralize(name) # extend with scope options by adding All
  options.listSearch       ?= false
  options.listReorder      ?= false
  options.listItemsPerPage ?= 25

  options.deletable  ?= true
  options.moduleName ?= _.underscored(_.pluralize(name))
  options.modelName  ?= name
  options.modelSlug  ?= _.underscored(name)

  options.implementation ?= Character.Generic

  # list scopes
  if options.listScopes
    if options.listScopes.default

      listDefaultOrderBy = options.listScopes.default.orderBy
      delete options.listScopes['default']

    _(options.listScopes).each (scope, slug) ->
      scope.title ||= _(slug).titleize()
      scope.slug  ||= slug

  listDefaultOrderBy ?= options.listDefaultOrderBy

  # include model fields
  imf = options.includeModelFields || []

  # list item template
  #  - options.listItem.titleField
  #  - options.listItem.metaField
  #  - options.listItem.thumbField
  imf.push( options.listItem.titleField )
  imf.push( options.listItem.metaField )
  imf.push( options.listItem.thumbField )

  options.includeModelFields = _.uniq(_.compact(imf))


  chr.module options.moduleName, (module) ->

    module = _(module).extend(options.implementation)

    module.on 'start', ->

      @collection = new @Collection()
      @collection.options =
        orderBy:          listDefaultOrderBy
        modelSlug:        options.modelSlug
        collectionUrl:    options.collectionUrl || "#{ chr.options.url }/#{ options.modelName }"
        scopes:           options.listScopes
        reorder:          options.listReorder
        search:           options.listSearch
        titleField:       options.listItem.titleField
        metaField:        options.listItem.metaField
        thumbField:       options.listItem.thumbField
        constantParams:
          f:              options.includeModelFields.join(',')
          pp:             options.listItemsPerPage

      options.module = module

      @controller = new @Controller(options)
      @layout     = new @Layout(options)
      @router     = new @Router({ path: options.moduleName, controller: @controller })

      chr.execute('addMenuItem', options.moduleName, options.menuIcon, options.menuTitle)