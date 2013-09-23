

@Character.module 'Settings.Layout', (Module, App) ->

  #========================================================
  # Main
  #========================================================
  Module.Main = Backbone.Marionette.Layout.extend
    className: 'chr-settings-layout'

    template: -> """<aside class='left-panel'>
                      <header class='chr-settings-list-header'>Settings</header>
                      <ul id='list' class='chr-settings-list'></ul>
                      <a href='/admin/logout' class='browserid_logout button radius secondary small'>
                        Logout<br><span id='user_email' class='user-email'>santyor@gmail.com</span>
                      </a>
                    </aside>
                    <div class='right-panel' id='view'></div>"""

    regions:
      view: '#view'

    ui:
      list:       '#list'
      user_email: '#user_email'

    onRender: ->
      @ui.user_email.html(App.options.user.email)
      @addMenu()

    addMenu: ->
      _.each App.Settings.Apps.submodules, (m) =>
        path = m.options.path
        name = m.options.name
        @ui.list.append("<li><a href='#/settings/#{ path}' class='#{ path}'>#{ name }</a></li>")

    setActiveMenuItem: (path) ->
      @ui.list.find('.active').removeClass('active')
      @ui.list.find("a.#{ path }").addClass('active')


  #========================================================
  # View
  #========================================================
  Module.View = Backbone.Marionette.ItemView.extend
    template: -> """<header id='header' class='chr-settings-view-header'>
                      <span class='title' id='title'></span><span class='chr-actions' id='actions'></span>
                      <aside class='right'><a href='#' class='chr-action-save action_save'>Save</a></aside>
                    </header>
                    <section id='form' class='chr-settings-view-form'></section>"""

    ui:
      title:              '#title'
      form:               '#form'
      actions:            '#actions'
      new_item_template:  '#new_item_template'

    onRender: ->
      @ui.title.html @options.name
      @ui.form.addClass @options.path
      $.get "/admin/settings/#{ @options.path }", (html) =>
        @ui.form.html(html)
        @onFormRendered()

    onFormRendered: ->
      @ui.new_item_template = @ui.form.find('#new_item_template')

      if @ui.new_item_template.length
        @ui.actions.append("<i class='chr-action-pin'></i><a class='action_new'>New</a>")

    events:
      'click .action_save':   'onSave'
      'click .action_new':    'addItem'
      'click .action_cancel': 'cancelItem'
      'click .action_delete': 'removeItem'

    onSave: -> alert 'save'

    addItem: ->
      html = @ui.new_item_template.html()
      html = html.replace(/objects\[\]\[\]/g, "objects[][#{ new Date().getTime() }]")
      @ui.new_item_template.before("<div class='new_item'>#{ html }</div>")
      #@update_position_values()

    cancelItem: (e) ->
      $(e.currentTarget).closest('.new_item').remove() ; return false

    removeItem: -> (e) ->
      item_cls = $(e.currentTarget).attr('data-item-class')

      if item_cls
        item = $(e.currentTarget).closest(".#{ item_cls }")

        destroy_field = _.find item.find("input[type=hidden]"), (f) ->
          name = $(f).attr('name')
          _(name).endsWith('[_destroy]')

        $(destroy_field).attr('value', 'true')
        item.replaceWith(destroy_field)

      return false