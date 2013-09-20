

@AppListHeader = Backbone.Marionette.ItemView.extend
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