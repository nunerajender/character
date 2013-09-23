

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
                    </header>
                    <section id='form_view' class='chr-settings-view-form'></section>"""

    ui:
      title:              '#title'
      actions:            '#actions'
      new_item_template:  '#new_item_template'
      form_view:          '#form_view'

    onRender: ->
      @ui.title.html(@options.name)
      @ui.form_view.addClass(@options.path)
      $.get "/admin/settings/#{ @options.path }", (html) =>
        @ui.form_view.html(html)
        @onFormRendered()

    onFormRendered: ->
      @ui.new_item_template = @ui.form_view.find('#new_item_template')
      if @ui.new_item_template.length > 0
        @ui.actions.append("<i class='chr-action-pin'></i><a class='action_new'>New</a>")

      @ui.form = @ui.form_view.find('form')
      if @ui.form.length > 0
        @ui.title.after("<aside class='right'><a class='chr-action-save'>Save</a></aside>")
        @ui.form.ajaxForm
          beforeSubmit: (arr, $form, options) -> $('.chr-action-save').addClass('disabled'); return true
          success: (response) -> $('.chr-action-save').removeClass('disabled')

    events:
      'click .chr-action-save': 'onSave'
      'click .action_new':      'addItem'
      'click .action_cancel':   'cancelItem'
      'click .action_delete':   'deleteItem'

    onSave: (e) ->
      (unless $(e.currentTarget).hasClass('disabled') then @ui.form.submit()) ; return false

    addItem: ->
      html = @ui.new_item_template.html()
      html = html.replace(/objects\[\]\[\]/g, "objects[][#{ new Date().getTime() }]")
      @ui.new_item_template.before("<div class='new_item'>#{ html }</div>")

    cancelItem: (e) ->
      $(e.currentTarget).closest('.new_item').remove() ; return false

    deleteItem: (e) ->
      item_cls = $(e.currentTarget).attr('data-item-class')

      if item_cls
        item = $(e.currentTarget).closest(".#{ item_cls }")

        destroy_field = _.find item.find("input[type=hidden]"), (f) ->
          name = $(f).attr('name')
          _(name).endsWith('[_destroy]')

        $(destroy_field).attr('value', 'true')
        item.replaceWith(destroy_field)

      return false