

class @GenericListHeader extends Backbone.Marionette.Layout
  tagEl:    'header'
  className: 'chr-generic-list-header'

  template: -> """<a class='title'></a><span class='actions'><a class='new'>New</a></span>
                  <aside class='right search'></aside>
                  <ul id='scopes' class='f-dropdown'></ul>"""

  ui:
    title:      '.title'
    actions:    '.actions'
    new_action: '.new'
    scopes:     '#scopes'
    search:     '.search'

  onRender: ->
    @update_title()
    @add_scopes()

  get_title: ->
    if @options.scopes then 'All ' + @options.pluralized_name else @options.pluralized_name

  update_title: (scope) ->
    title = @get_title()
    link  = "#/#{ @options.path }"

    if scope
      link += "/#{ scope }"

    @ui.title.html(title)
    @ui.title.attr('href', link)

    @ui.new_action.attr('href', "#{ link }/new")

  add_scopes: ->
    scopes = @options.scopes
    if not scopes then return

    @ui.title.html(@get_title())
    @ui.title.addClass('dropdown').attr('data-dropdown', 'scopes')

    @ui.scopes.append """<li><a href='#/#{ @options.path }'>#{ @get_title() }</a></li>"""

    _.each scopes, (opts, scope) =>
      title = opts.title || _(scope).titleize()
      @ui.scopes.append """<li><a href='#/#{ @options.path }/#{ scope }'>#{ title }</a></li>"""