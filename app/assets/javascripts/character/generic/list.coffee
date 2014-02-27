
#
# Marionette.js Item View Documentation
# https://github.com/marionettejs/backbone.marionette/blob/master/docs/marionette.itemview.md
#
@Character.Generic.ListHeaderView = Backbone.Marionette.ItemView.extend
  template: -> "<aside id=list_search class=chr-list-search>
                  <i class='chr-icon icon-search icon-flip'></i>
                  <input type=search placeholder='Search...' />
                  <a id=list_search_hide href='#'><i class='chr-icon icon-close'></i></a>
                </aside>
                <a id=list_search_show class=search title='Search' href='#'><i class='chr-icon icon-search'></i></a>
                <a id=new class=new title='Create new item' href='#'><i class='chr-icon icon-plus'></i></a>
                <div class=scope><span id=list_title class=title></span></div>"

  ui:
    title:         '#list_title'
    search:        '#list_search'
    searchInput:   '#list_search input'
    searchShow:    '#list_search_show'
    newAction:     '#new'

  events:
    'click #list_search_hide':  'hideSearch'
    'click #list_search_show':  'showSearch'
    'keyup #list_search input': 'onKeyup'
    'click #list_title':        'toggleScopesMenu'

  onKeyup: (e) ->
    if @searchTypeTimeout
      clearTimeout(@searchTypeTimeout)

    return @toggleSearchBar() if e.keyCode == 27

    query = @ui.searchInput.val()

    search = =>
      @collection.setSearchQuery(query).fetchPage(1)

    if e.keyCode == 13
      search()
    else
      @searchTypeTimeout = setTimeout(search, 800)

  showSearch: ->
    @ui.search.addClass('active')
    @ui.searchInput.focus()
    false

  hideSearch: ->
    @ui.search.removeClass('active')
    @ui.searchInput.val('')
    @collection.setSearchQuery()
    @collection.fetchPage(1)
    false

  onRender: ->
    @collection = @options.module.collection
    @scopes     = @options.listScopes
    @path       = "#/#{ @options.moduleName }"

    if not @options.newItems
      @ui.newAction.hide()

    if @options.listSearch
      @ui.searchShow.show()
    else
      @ui.searchShow.hide()

    @afterOnRender() if @afterOnRender

  update: (scopeSlug) ->
    title = @options.listTitle
    path  = @path

    if @scopes and scopeSlug
      title = @scopes[scopeSlug].title
      path += '/' + @scopes[scopeSlug].slug

    @ui.title.html(title).parent().attr('href', path)

    @ui.newAction.attr('href', path + "/new")

    @addScopesDropdown()

  addScopesDropdown: ->
    if @scopes and _(@scopes).keys().length > 0
      if not @ui.scopes
        @ui.scopes = $('<ul />')
        @ui.scopes.append """<li><a href='#{ @path }'>#{ @options.listTitle }</a></li>"""

        _.each @scopes, (scope, key) =>
          @ui.scopes.append """<li><a href='#{ @path }/#{ scope.slug }'>#{ scope.title }</a></li>"""

        @ui.title.after(@ui.scopes).addClass('dropdown')

      # update active scope link
      currentScopeTitle = @ui.title.html()
      @ui.scopes.find('a').each (i, el) ->
        if $(el).html() == currentScopeTitle then $(el).addClass('active') else $(el).removeClass('active')

      # hide scopes menu
      @ui.scopes.removeClass 'show'

  toggleScopesMenu: ->
    @ui.scopes.toggleClass 'show'

  onClose: ->

#
# Marionette.js Item View Documentation
# https://github.com/marionettejs/backbone.marionette/blob/master/docs/marionette.itemview.md
#
@Character.Generic.ListEmtpyView = Backbone.Marionette.ItemView.extend
  tagName:   'li'
  className: 'empty'
  template: -> "No items found"


#
# Marionette.js Item View Documentation
# https://github.com/marionettejs/backbone.marionette/blob/master/docs/marionette.itemview.md
#
@Character.Generic.ListItemView = Backbone.Marionette.ItemView.extend
  tagName:   'li'
  className: 'chr-list-item'

  template: (item) ->  """<a title='#{ item.__title }'>
                            <img src='#{ item.__thumb }' class='thumbnail' />
                            <div class='container'>
                              <div class='title'>#{ item.__title }</div>
                              <div class='meta'>#{ item.__meta }</div>
                            </div>
                          </a>"""

  modelEvents:
    'change':  'render'
    'destroy': 'remove'

  ui:
    link: 'a'

  onRender: ->
    path = chr.currentPath

    if @model.getThumb()
      @$el.addClass('has-thumbnail')

    @ui.link.attr('href', "#/#{ path }/edit/#{ @model.id }")

    @$el.attr('data-id', @model.id)
    @$el.attr('data-position', @model.getPosition())


#
# Marionette.js Collection View Documentation
# https://github.com/marionettejs/backbone.marionette/blob/master/docs/marionette.collectionview.md
#
@Character.Generic.ListView = Backbone.Marionette.CollectionView.extend
  tagName: 'ul'

  itemViewOptions: (model, index) ->
    module: @options.module

  initialize: ->
    @itemView  = @options.module.ListItemView
    @emptyView = @options.module.ListEmtpyView

    @listenTo(@collection, 'sort', @render, @)

  loadMoreItems: ->
    # NOTE: This still will request a new page every time if last item is last on last page
    if @collection.size() == @collection.page * @collection.options.constantParams.pp
      if not @loading_more_items_in_progress
        @loading_more_items_in_progress = true
        @collection.fetchNextPage =>
          @loading_more_items_in_progress = false

  onRender: ->
    @$el.parent().scroll (e) =>
      if e.target.offsetHeight + e.target.scrollTop + 272 > @$el.height()
        @loadMoreItems()

    if @selected_item_id
      @selectItem(@selected_item_id)

    if @collection.options.reorder
      Character.Generic.Plugins.startReorder(@$el, @collection)

  selectItem: (id) ->
    @selected_item_id = id
    @$el.find('li.active').removeClass('active')
    @$el.find("li[data-id=#{ id }]").addClass('active')

  unselectCurrentItem: ->
    @selected_item_id = null
    @$el.find('li.active').removeClass('active')

  onClose: ->
    if @collection.options.reorder
      Character.Generic.Plugins.stopReorder(@$el)