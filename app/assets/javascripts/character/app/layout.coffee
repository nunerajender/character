

@Character.module 'App.Layout', (Module, App) ->

  #========================================================
  # Main
  #========================================================
  Module.Main = Backbone.Marionette.Layout.extend
    className: 'chr-app-layout'

    template: -> """<div class='left-panel'>
                      <div id='list_header' class='chr-app-list-header'></div>
                      <div id='list_content' class='chr-app-list'></div>
                    </div>
                    <aside class='right-panel logo' id='logo'></aside>"""

    regions:
      list_header:  '#list_header'
      list_content: '#list_content'

    onRender: ->
      @header = new Module.ListHeader(@options)
      @list   = new Module.List({ collection: @options.app.collection })

      @list_header.show(@header)
      @list_content.show(@list)

  #========================================================
  # List Header
  #========================================================
  Module.ListHeader = Backbone.Marionette.ItemView.extend
    template: -> """<a class='title'></a><span class='actions'><a class='new'>New</a></span>
                    <aside class='right search'></aside>
                    <ul id='scopes' class='f-dropdown'></ul>"""

    ui:
      title:      '.title'
      actions:    '.actions'
      new_action: '.new'
      search:     '.search'
      scopes:     '#scopes'

    update: (scope_slug) ->
      title = @options.pluralized_name
      link  = "#/#{ @options.path }"

      if @options.scopes
        if scope_slug
          title = @options.scopes[scope_slug].title
          link += '/' + @options.scopes[scope_slug].slug
        else
          title = 'All ' + @options.pluralized_name

      @ui.title.html(title)
      @ui.title.attr('href', link)
      @ui.new_action.attr('href', link + "/new")

      if @options.scopes
        @add_scopes()

    add_scopes: ->
      scopes = @options.scopes

      @ui.title.addClass('dropdown').attr('data-dropdown', 'scopes')

      @ui.scopes.append """<li><a href='#/#{ @options.path }'>#{ 'All ' + @options.pluralized_name }</a></li>"""
      _.each scopes, (scope, key) =>
        @ui.scopes.append """<li><a href='#/#{ @options.path }/#{ scope.slug }'>#{ scope.title }</a></li>"""


  #========================================================
  # ListEmpty
  #========================================================
  Module.ListEmtpy = Backbone.Marionette.ItemView.extend
    template: -> """<div class='empty'>No items found</div>"""


  #========================================================
  # ListItem
  #========================================================
  Module.ListItem = Backbone.Marionette.ItemView.extend
    tagName:   'li'
    className: 'chr-app-list-item'

    template: (item) ->  """<a title='#{ item.__title }'>
                              <img src='#{ item.__image }' />
                              <div class='container'>
                                <strong class='title'>#{ item.__title }</strong>
                                <span class='meta'>#{ item.__meta }</span>
                              </div>
                            </a>"""

    modelEvents:
      'change':  'render'
      'destroy': 'remove'

    ui:
      link: 'a'

    onRender: ->
      # update link according to the current state
      @ui.link.attr('href', location.hash + "/edit/#{ @model.get('_id') }")

      # reordering helpers
      @$el.attr('data-id', @model.id)
      @$el.attr('data-position', @model.get('_position'))


  #========================================================
  # List
  #========================================================
  Module.List = Backbone.Marionette.CollectionView.extend
    tagName:   'ul'
    itemView:  Module.ListItem
    emptyView: Module.ListEmtpy

    initialize: ->
      @listenTo(@collection, 'sort', @render, @)

    onRender: ->
      if @options.reorderable then character_list.sortable(@$el, @collection)