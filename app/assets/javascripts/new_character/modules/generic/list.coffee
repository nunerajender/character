
#
# Marionette.js Item View Documentation
# https://github.com/marionettejs/backbone.marionette/blob/master/docs/marionette.itemview.md
#
@Character.Generic.ListHeaderView = Backbone.Marionette.ItemView.extend
  template: -> "<a class='title'></a>
                <span class='chr-actions'>
                  <i class='chr-action-pin'></i><a class='new'>New</a>
                </span>
                <aside class='right search'>
                  <input type='text' placeholder='Type your search here...' />
                  <a href='#'><i class='fa fa-times'></i><i class='fa fa-search'></i></a>
                </aside>
                <ul id='scopes' class='f-dropdown' data-dropdown-content></ul>"

  ui:
    title:         '.title'
    actions:       '.actions'
    new_action:    '.new'
    search:        '.search'
    searchInput:   '.search input'
    scopes:        '#scopes'

  events:
    'click .search a':     'toggleSearchBar'
    'keyup .search input': 'onKeyup'

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

  toggleSearchBar: ->
    if @ui.search.hasClass('shown')
      @ui.search.removeClass('shown')
      @ui.searchInput.val('')

      @collection.setSearchQuery()
      @collection.fetchPage(1)
    else
      @ui.search.addClass('shown')
      @ui.searchInput.focus()
    false

  onRender: ->
    @collection = @options.module.collection
    @scopes     = @options.listScopes
    @path       = "#/#{ @options.moduleName }"

    if @options.listSearch
      @ui.search.show()
    else
      @ui.search.hide()

    @afterOnRender() if @afterOnRender

  update: (scopeSlug) ->
    title = @options.listTitle
    path  = @path

    if @scopes and scopeSlug
      title = @scopes[scopeSlug].title
      path += '/' + @scopes[scopeSlug].slug

    @ui.title.html(title).attr('href', path)

    @ui.new_action.attr('href', path + "/new")

    @addScopesDropdown()

  addScopesDropdown: ->
    if @scopes
      @ui.title.addClass('dropdown').attr('data-dropdown', 'scopes')

      @ui.scopes.append """<li>
                             <a href='#{ @path }'>#{ @options.listTitle }</a>
                           </li>"""

      _.each @scopes, (scope, key) =>
        @ui.scopes.append """<li>
                               <a href='#{ @path }/#{ scope.slug }'>#{ scope.title }</a>
                             </li>"""

      $(document).foundation('dropdown', 'init')

  onClose: ->
    if @scopes
      $(document).foundation('dropdown', 'off')


#
# Marionette.js Item View Documentation
# https://github.com/marionettejs/backbone.marionette/blob/master/docs/marionette.itemview.md
#
@Character.Generic.ListEmtpyView = Backbone.Marionette.ItemView.extend
  template: -> """<div class='empty'>No items found</div>"""


#
# Marionette.js Item View Documentation
# https://github.com/marionettejs/backbone.marionette/blob/master/docs/marionette.itemview.md
#
@Character.Generic.ListItemView = Backbone.Marionette.ItemView.extend
  tagName:   'li'
  className: 'chr-module-generic-list-item'

  template: (item) ->  """<a title='#{ item.__title }'>
                            <img src='#{ item.__thumb }' />
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
    path = chr.currentModuleName

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
      Character.Utils.enableListReorder(@$el, @collection)

  selectItem: (id) ->
    @selected_item_id = id
    @$el.find('li.active').removeClass('active')
    @$el.find("li[data-id=#{ id }]").addClass('active')

  unselectCurrentItem: ->
    @selected_item_id = null
    @$el.find('li.active').removeClass('active')

  onClose: ->
    if @collection.options.reorder
      Character.Utils.disableListReorder(@$el)