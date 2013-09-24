

@Character.module 'App.Layout', (Module, App) ->

  #========================================================
  # Main
  #========================================================
  Module.Main = Backbone.Marionette.Layout.extend
    className: 'chr-app-layout'

    template: -> """<div class='left-panel'>
                      <div id=list_header class='chr-app-list-header'></div>
                      <div id=list_content class='chr-app-list'></div>
                    </div>
                    <div id=view class='right-panel logo'></div>"""

    regions:
      list_header:  '#list_header'
      list_content: '#list_content'
      view:         '#view'

    onRender: ->
      @header = new Module.ListHeader(@options)
      @list   = new Module.List({ collection: @options.app.collection })

      @list_header.show(@header)
      @list_content.show(@list)


  #========================================================
  # List Header
  #========================================================
  Module.ListHeader = Backbone.Marionette.ItemView.extend
    template: -> """<a class='title'></a><span class='chr-actions'><i class='chr-action-pin'></i><a class='new'>New</a></span>
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
        @addScopesDropdown()

    addScopesDropdown: ->
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
      @ui.link.attr('href', "#/#{ App.path }/edit/#{ @model.id }")

      # reordering helpers
      @$el.attr('data-id', @model.id)
      @$el.attr('data-position', @model.getPosition())


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

    selectItem: (id) ->
      @$el.find('li.active').removeClass('active')
      @$el.find("li[data-id=#{ id }]").addClass('active')


  #========================================================
  # View
  #========================================================
  Module.View = Backbone.Marionette.Layout.extend
    className: 'chr-app-view'
    template: -> "<header id=header class='chr-app-view-header'></header>
                  <div id=form_view class='chr-app-view-form'></div>"

    regions:
      header: '#header'

    ui:
      action_save:   '#action_save'
      action_delete: '#action_delete'
      form_view:     '#form_view'

    onRender: ->
      @header.show(new Module.ViewHeader({ model: @model, name: @options.name }))
      @$el.addClass if @model then 'edit' else 'new'
      url = "#{ @options.url }/" + if @model then "#{ @model.id }/edit" else "new"
      $.get url, (html) => @updateContent(html)

    updateContent: (form_html) ->
      ( @ui.form_view.html(form_html) ; @onFormRendered() ) if @ui.form_view

    onFormRendered: ->
      @ui.form = @ui.form_view.find('form')
      if @ui.form.length > 0
        @ui.form.ajaxForm
          beforeSubmit: (arr, $form, options) =>
            # date fixes for rails
            _.each simple_form.get_date_values(arr), (el) -> arr.push el
            @ui.action_save.addClass('disabled')
            return true
          success: (resp) => @ui.action_save.removeClass('disabled') ; @updateModel(resp)

      # layout fix for date selectors
      simple_form.set_foundation_date_layout()

      # @ui.form.addClass('custom')
      # @ui.form.foundation('forms', 'assemble')
      # @ui.form.foundation('section', 'resize')

    updateModel: (resp) ->
      # when response is a string, that means form with errors returned
      if typeof(resp) == 'string' then return @updateContent(resp)
      # assuming response is json
      if @model then @model.set(resp) else @options.collection.add(resp)
      @options.collection.sort()

    events:
      'click #action_save':   'onSave'
      'click #action_delete': 'onDelete'

    onSave: ->
      @ui.form.submit() ; return false

    onDelete: ->
      if confirm("""Are you sure about deleting "#{ @model.getTitle() }"?""")
        @close() ; @model.destroy() ; @options.router.navigate(App.path)
      return false


  #========================================================
  # View Header
  #========================================================
  Module.ViewHeader = Backbone.Marionette.ItemView.extend
    template: -> "<span id=view_title class='title'></span><span class='chr-actions'><i class='chr-action-pin'></i><a id=action_delete>Delete</a></span>
                  <div id=view_meta class='meta'></div>
                  <a id='action_save' class='chr-action-save'>
                    <span class='create'>Create</span>
                    <span class='save'>Save</span>
                  </a>"

    ui:
      title: '#view_title'
      meta:  '#view_meta'

    initialize: ->
      @listenTo(@model, 'change', @render, @) if @model

    onRender: ->
      @ui.title.html if @model then @model.getTitle() else "New #{ @options.name }"
      @ui.meta.html("Updated #{ moment(@model.get('updated_at')).fromNow() }") if @model