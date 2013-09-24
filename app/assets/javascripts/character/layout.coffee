

@Character.module 'Layout', (Module, App) ->

  #========================================================
  # Main
  #========================================================
  Module.Main = Backbone.Marionette.Layout.extend
    id:        'character'
    className: 'character'

    template: -> """<div id='menu' class='chr-menu'></div><div id='content' class='chr-content'></div>"""

    onRender: ->
      @menu.show(new Module.Menu())

    regions:
      menu:    '#menu'
      content: '#content'

  #========================================================
  # Menu
  #========================================================
  Module.Menu = Backbone.Marionette.ItemView.extend
    tagName:   'nav'
    template: -> """<img id='user_avatar' src="">
                    <ul id='menu_items'></ul>
                    <a href='/admin/logout' class='browserid_logout'><i class="icon-signout"></i>Logout</a>"""

    ui:
      items:  '#menu_items'
      avatar: '#user_avatar'

    addItem: (path, icon, title) ->
      @ui.items.append("<li><a href='#/#{ path }' class='mi-#{ path }'><i class='icon-#{ icon }'></i>#{ title }</a></li>")

    selectItem: (cls) ->
      @$el.find('a.active').removeClass('active')
      @$el.find("a.mi-#{cls}").addClass('active')

    firstItem: ->
      @ui.items.find('a:eq(0)')

  #========================================================
  # Init
  #========================================================
  Module.addInitializer (options) ->
    layout = new Module.Main()
    layout.render().$el.prependTo('body')

    App.options = options
    App.main    = layout.content
    App.menu    = layout.menu.currentView

    # set user avatar
    App.menu.ui.avatar.attr('src', options.user.avatar_url)

    # add project logo
    $("<style>.logo{background-image:url('#{ options.logo }');}</style>").appendTo("head")

    # initialize foundation plugins
    $(document).foundation('section forms dropdown')