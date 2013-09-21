

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
    template: -> """<header id='header' class='chr-settings-view-header'><span class='title'>Admins</span></header>
                    <section id='form' class='chr-settings-view-form'></section>"""

    ui:
      form: '#form'