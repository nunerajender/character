@Character.Settings ||= {}
@Character.Settings.MainView = Backbone.Marionette.Layout.extend
  className: 'chr-settings-main'

  template: -> """<aside class='left-panel'>
                    <header class='chr-settings-list-header'>Settings</header>
                    <ul id=list class='chr-settings-list'></ul>
                    <a href='/admin/logout' class='browserid_logout button radius secondary small'>
                      Logout<br><span id='user_email' class='user-email'>santyor@gmail.com</span>
                    </a>
                  </aside>
                  <div id=details class='right-panel'></div>"""

  regions:
    details: '#details'

  ui:
    list:       '#list'
    user_email: '#user_email'

  onRender: ->
    @ui.user_email.html(chr.options.user.email)
    @addMenu()

  addMenu: ->
    _.each chr.Settings.submodules, (m) =>
      path = m.options.path
      name = m.options.name
      @ui.list.append("<li><a href='#/settings/#{ path}' class='#{ path}'>#{ name }</a></li>")

  setActiveMenuItem: (path) ->
    @ui.list.find('.active').removeClass('active')
    @ui.list.find("a.#{ path }").addClass('active')