#
# Marionette.js Layout Documentation
# https://github.com/marionettejs/backbone.marionette/blob/master/docs/marionette.layout.md
#
@Character.Settings.Layout = Backbone.Marionette.Layout.extend
  tagName: 'section'
  className: 'chr-module-generic'

  template: -> """<aside class='left-panel'>
                    <header class='chr-module-generic-list-header'>
                      Settings <a href='' class='browserid_logout button radius secondary small'>Sign out</a>
                    </header>
                    <div id=list_content class='chr-module-generic-list'>
                      <ul id=list></ul>

                    </div>
                  </aside>
                  <div id=details class='right-panel chr-logo'></div>"""

  regions:
    details: '#details'

  ui:
    list:          '#list'
    user_email:    '#user_email'
    action_logout: '.browserid_logout'

  onRender: ->
    submodules = @options.module.submodules

    @ui.action_logout.attr('href', chr.options.url + '/logout')
    @ui.user_email.html(chr.options.user_email)

    # add left menu options
    _.each submodules, (m) =>
      title = m.options.titleMenu
      name  = m.options.moduleName
      @ui.list.append """<li class='chr-module-generic-list-item'>
                           <a href='#/settings/#{ name }' class='#{ name }'><div class='title'>#{ title }</div></a>
                         </li>"""

  setActiveMenuItem: (path) ->
    @ui.list.find('.active').removeClass('active')
    @ui.list.find("a.#{ path }").parent().addClass('active')