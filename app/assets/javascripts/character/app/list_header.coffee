@Character.App ||= {}
@Character.App.ListHeaderView = Backbone.Marionette.ItemView.extend
  template: -> "<a class='title'></a>
                <span class='chr-actions'><i class='chr-action-pin'></i><a class='new'>New</a></span>
                <aside class='right search'>
                  <input type='text' placeholder='Type your search here...' />
                  <a href='#'><i class='fa fa-times'></i><i class='fa fa-search'></i></a>
                </aside>
                <ul id='scopes' class='f-dropdown'></ul>"

  ui:
    title:         '.title'
    actions:       '.actions'
    new_action:    '.new'
    search:        '.search'
    search_input:  '.search input'
    scopes:        '#scopes'


  events:
    'click .search a':     'toggleSearchBar'
    'keyup .search input': 'onKeyup'


  onKeyup: (e) ->
    if @search_on_type_timeout
      clearTimeout(@search_on_type_timeout)

    return @toggleSearchBar() if e.keyCode == 27

    query = @ui.search_input.val()

    if e.keyCode == 13
      @options.app.collection.search(query)
    else
      @search_on_type_timeout = setTimeout((=> @options.app.collection.search(query)), 800)


  toggleSearchBar: ->
    if @ui.search.hasClass('shown')
      @ui.search.removeClass('shown')
      @ui.search_input.val('')
      @options.app.collection.search(false)
    else
      @ui.search.addClass('shown')
      @ui.search_input.focus()
    false


  onRender: ->
    if @options.search then @ui.search.show() else @ui.search.hide()

    @afterOnRender() if @afterOnRender


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
      @addScopesDropdown()


  addScopesDropdown: ->
    scopes = @options.scopes

    @ui.title.addClass('dropdown').attr('data-dropdown', 'scopes')

    @ui.scopes.append """<li><a href='#/#{ @options.path }'>#{ 'All ' + @options.pluralized_name }</a></li>"""
    _.each scopes, (scope, key) =>
      @ui.scopes.append """<li><a href='#/#{ @options.path }/#{ scope.slug }'>#{ scope.title }</a></li>"""