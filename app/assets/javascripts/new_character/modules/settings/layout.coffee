#
# Marionette.js Layout Documentation
# https://github.com/marionettejs/backbone.marionette/blob/master/docs/marionette.layout.md
#
@Character.Settings.Layout = Backbone.Marionette.Layout.extend
  tagName: 'section'
  className: 'chr-module-settings'

  template: -> """<aside class='left-panel'>
                    <header class='chr-module-settings-list-header'>Settings</header>

                    <ul id=list class='chr-module-settings-list'></ul>

                    <a href='' class='browserid_logout button radius secondary small'>
                      <strong>Sign out</strong><br><span id='user_email' class='user-email'></span>
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
    @ui.action_logout.attr('href', chr.options.url + '/logout')
    @ui.user_email.html(chr.options.user_email)

    # add left menu options
    _.each chr.Settings.submodules, (m) =>
      title = m.options.titleMenu
      name  = m.options.moduleName
      @ui.list.append("<li><a href='#/settings/#{ name }' class='#{ name }'>#{ title }</a></li>")

  setActiveMenuItem: (path) ->
    @ui.list.find('.active').removeClass('active')
    @ui.list.find("a.#{ path }").addClass('active')