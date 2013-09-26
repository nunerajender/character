
@Character.App ||= {}

#========================================================
# Main
#========================================================
@Character.App.MainView = Backbone.Marionette.Layout.extend
  className: 'chr-app-main'

  template: -> "<div class='left-panel'>
                  <div id=list_header class='chr-app-list-header'></div>
                  <div id=list_content class='chr-app-list'></div>
                </div>
                <div id=details class='right-panel logo'></div>"

  regions:
    list_header:  '#list_header'
    list_content: '#list_content'
    details:      '#details'

  initialize: ->
    @ListHeaderView = @options.app.ListHeaderView
    @ListView = @options.app.ListView

  onRender: ->
    @header = new @ListHeaderView(@options)
    @list   = new @ListView({ collection: @options.app.collection, app: @options.app })

    @list_header.show(@header)
    @list_content.show(@list)


#========================================================
# List Header
#========================================================
@Character.App.ListHeaderView = Backbone.Marionette.ItemView.extend
  template: -> "<a class='title'></a><span class='chr-actions'><i class='chr-action-pin'></i><a class='new'>New</a></span>
                <aside class='right search'></aside>
                <ul id='scopes' class='f-dropdown'></ul>"

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
      @addScopesDropdown()

  addScopesDropdown: ->
    scopes = @options.scopes

    @ui.title.addClass('dropdown').attr('data-dropdown', 'scopes')

    @ui.scopes.append """<li><a href='#/#{ @options.path }'>#{ 'All ' + @options.pluralized_name }</a></li>"""
    _.each scopes, (scope, key) =>
      @ui.scopes.append """<li><a href='#/#{ @options.path }/#{ scope.slug }'>#{ scope.title }</a></li>"""


#========================================================
# List Empty
#========================================================
@Character.App.ListEmtpyView = Backbone.Marionette.ItemView.extend
  template: -> """<div class='empty'>No items found</div>"""


#========================================================
# List Item
#========================================================
@Character.App.ListItemView = Backbone.Marionette.ItemView.extend
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
    @$el.addClass('has-thumbnail') if @model.getImage()
    @ui.link.attr('href', "#/#{ chr.path }/edit/#{ @model.id }")

    @$el.attr('data-id', @model.id)
    @$el.attr('data-position', @model.getPosition())


#========================================================
# List
#========================================================
@Character.App.ListView = Backbone.Marionette.CollectionView.extend
  tagName: 'ul'

  initialize: ->
    @itemView  = @options.app.ListItemView
    @emptyView = @options.app.ListEmtpyView

    @listenTo(@collection, 'sort', @render, @)

  onRender: ->
    @selectItem(@selected_item_id) if @selected_item_id
    if @collection.options.reorderable then App.Plugins.reorderable(@$el, @collection)

  selectItem: (id) ->
    @selected_item_id = id
    @$el.find('li.active').removeClass('active')
    @$el.find("li[data-id=#{ id }]").addClass('active')

  unselectCurrentItem: ->
    @selected_item_id = null
    @$el.find('li.active').removeClass('active')


#========================================================
# View
#========================================================
@Character.App.DetailsView = Backbone.Marionette.Layout.extend
  className: 'chr-app-details'
  template: -> "<header id=header class='chr-app-details-header'></header>
                <div id=form_view class='chr-app-details-form'></div>"

  regions:
    header: '#header'

  ui:
    action_save:   '#action_save'
    action_delete: '#action_delete'
    form_view:     '#form_view'

  initialize: ->
    @DetailsHeaderView = @options.app.DetailsHeaderView
    @router = @options.app.router

  onRender: ->
    header_view = new @DetailsHeaderView({ model: @model, name: "New #{ @options.name }" })
    @header.show(header_view)

    @$el.addClass('edit') if @model

    $.get @options.url, (html) => @updateContent(html)

  updateContent: (form_html) ->
    ( @ui.form_view.html(form_html) ; @onFormRendered() ) if @ui.form_view

  onFormRendered: ->
    @ui.form = @ui.form_view.find('form')
    if @ui.form.length > 0

      # include fields to properly update item in a list and sort
      params = @collection.options.constant_params
      if @collection.sortField
        params.fields_to_include = [ params.fields_to_include, @collection.sortField ].join(',')

      @ui.form.ajaxForm
        data: params
        beforeSubmit: (arr, $form, options) =>
          # date fixes for rails
          _(Character.Plugins.get_date_field_values(arr)).each (el) -> arr.push(el)
          @ui.action_save.addClass('disabled')
          return true
        success: (resp) => @ui.action_save.removeClass('disabled') ; @updateModel(resp)

    Character.Plugins.fix_date_field_layout()

    # @ui.form.addClass('custom')
    # @ui.form.foundation('forms', 'assemble')
    # @ui.form.foundation('section', 'resize')

  updateModel: (resp) ->
    # when response is a string, that means form with errors returned
    if typeof(resp) == 'string' then return @updateContent(resp)
    # assuming response is json
    if @model then @model.set(resp) else @collection.add(resp)
    @collection.sort()

  events:
    'click #action_save':   'onSave'
    'click #action_delete': 'onDelete'

  onSave: ->
    @ui.form.submit() ; return false

  onDelete: ->
    if confirm("""Are you sure about deleting "#{ @model.getTitle() }"?""")
      @close() ; @model.destroy() ; @router.navigate(App.path)
    return false


#========================================================
# View Header
#========================================================
@Character.App.DetailsHeaderView = Backbone.Marionette.ItemView.extend
  template: -> "<span id=details_title class='title'></span><span class='chr-actions'><i class='chr-action-pin'></i><a id=action_delete>Delete</a></span>
                <div id=details_meta class='meta'></div>
                <a id='action_save' class='chr-action-save'><span class='create'>Create</span><span class='save'>Save</span></a>"

  ui:
    title: '#details_title'
    meta:  '#details_meta'

  initialize: ->
    @listenTo(@model, 'change', @render, @) if @model

  onRender: ->
    @ui.title.html if @model then @model.getTitle() else @options.name
    @ui.meta.html("Updated #{ moment(@model.get('updated_at')).fromNow() }") if @model