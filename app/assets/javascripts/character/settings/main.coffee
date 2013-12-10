@Character.Settings ||= {}
@Character.Settings.MainView = Backbone.Marionette.Layout.extend
  className: 'chr-settings-main'

  template: -> """<aside class='left-panel'>
                    <header class='chr-settings-list-header'>Settings</header>
                    <ul id=list class='chr-settings-list'></ul>
                    <a href='logout' class='browserid_logout button radius secondary small'>
                      <strong>Sign out</strong><br><span id='user_email' class='user-email'>santyor@gmail.com</span>
                    </a>
                  </aside>
                  <div id=details class='right-panel logo'></div>"""

  regions:
    details: '#details'

  ui:
    list:          '#list'
    user_email:    '#user_email'
    action_logout: '.browserid_logout'

  onRender: ->
    @ui.action_logout.attr 'href', chr.options.url + '/logout'
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