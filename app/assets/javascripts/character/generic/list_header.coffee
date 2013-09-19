

class @GenericListHeader extends Backbone.Marionette.Layout
  tagEl:    'header'
  className: 'chr-generic-list-header'

  template: -> """<a class='title'></a><span class='actions'><a class='new'>New</a></span>"""

  # <ul id="scopes" class="f-dropdown" data-dropdown-content=""><li><a href="#/posts">All Posts</a></li><li><a href="#/posts/published">Published</a></li><li><a href="#/posts/drafts">Drafts</a></li></ul>"""

  ui:
    title:      '.title'
    actions:    '.actions'
    new_action: '.new'

  onRender: ->
    @update()

  update: (scope) ->
    title = @options.pluralized_name
    link  = "#/#{ @options.path }"

    if scope
      title = 'scope' #collection_scope.title
      link += "/#{ scope }"

    @ui.title.html(title)
    @ui.title.attr('href', link)

    @ui.new_action.attr('href', "#{ link }/new")

  add_scopes: ->
    #