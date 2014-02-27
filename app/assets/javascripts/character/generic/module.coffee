#= require_self
#= require ./model
#= require ./layout
#= require ./details
#= require_tree ./helpers

@Character.Generic ||= {}
@Character.Generic.Plugins ||= {}

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
    @module.layout.closeDetails()

    path = @options.moduleName + ( if listScope then "/#{ listScope }" else '' )

    if chr.currentPath != path
      chr.currentPath = path
      @module.layout.updateListScope(listScope, callback)
    else
      callback?()

  new: (listScope) ->
    @index(listScope)
    detailsLayout = new @module.DetailsLayout
      model:      no
      collection: @collection
      objectName: @options.objectName
      module:     @module
      formUrl:    "#{ chr.options.url }/#{ @options.modelName }/new"
    @module.layout.details.show(detailsLayout)

  edit: (listScope, id) ->
    @index(listScope, =>
      @module.layout.list.selectItem(id)
      doc = @collection.get(id)
      detailsLayout = new @module.DetailsLayout
        model:      doc
        collection: @collection
        formUrl:    "#{ chr.options.url }/#{ @options.modelName }/#{ id }/edit"
        deletable:  @options.deletable
        module:     @module
      @module.layout.details.show(detailsLayout)
    )

#
# Character Generic Module
# Initialize function
#
chr.genericModule = (name, options={}) ->
  options.menuTitle ?= name
  options.menuIcon  ?= 'bolt'

  options.listTitle        ?= _.pluralize(name)
  options.listSearch       ?= false
  options.listReorder      ?= false
  options.listItemsPerPage ?= 25

  options.newItems   ?= true
  options.deletable  ?= true
  options.moduleName ?= _.underscored(_.pluralize(name))
  options.objectName ?= name
  options.modelName  ?= name
  options.modelSlug  ?= _.underscored(name)

  options.implementation ?= Character.Generic

  # list scopes
  if options.listScopes
    if options.listScopes.default
      listDefaultOrderBy = options.listScopes.default.orderBy
      delete options.listScopes['default']

    _(options.listScopes).each (scope, slug) ->
      scope.title ||= scope.title || _(slug).titleize()
      scope.slug  ||= slug

  # when reorder, consider of using _position field with desc sorting
  if options.listReorder
    listDefaultOrderBy = '_position:desc'

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