
@Character.App ||= {}

#========================================================
# Controller
#========================================================
@Character.App.Controller = Backbone.Marionette.Controller.extend
  initialize: -> @app = @options.app

  index: (scope, callback) ->
    current_path = "#{ @options.path }" + ( if scope then "/#{ scope }" else '')
    if chr.path != current_path
      chr.path = current_path
      chr.menu.selectItem(@options.path)
      chr.main.show(@app.main)
      @app.main.header.update(scope)

      @app.collection.scope(scope, callback)
    else
      @app.main.list.unselectCurrentItem()
      @app.main.details.close()
      callback?()

  new: (scope) ->
    @index(scope)
    view = new @app.DetailsView
      model:      no
      name:       @options.name
      url:        @app.collection.options.collection_url + "/new"
      collection: @app.collection
      app:        @app
    @app.main.details.show(view)

  edit: (scope, id) ->
    @index scope, =>
      doc = @app.collection.get(id)
      @app.main.list.selectItem(id)
      view = new @app.DetailsView
        model:      doc
        name:       @options.name
        url:        @app.collection.options.collection_url + "/#{ id }/edit"
        collection: @app.collection
        app:        @app
        deletable:  @options.deletable
      @app.main.details.show(view)