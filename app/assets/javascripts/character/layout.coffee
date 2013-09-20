

@Character.module 'Layout', (Module, App) ->
  Module.Main = Backbone.Marionette.Layout.extend
    id:        'character'
    className: 'character'

    template: -> """<div id='menu' class='chr-menu'></div><div id='content' class='chr-content'></div>"""

    onRender: ->
      @menu.show(new Module.Menu())

    regions:
      menu:    '#menu'
      content: '#content'


  Module.Menu = Backbone.Marionette.ItemView.extend
    tagName:   'nav'
    template: -> """<img id='user_avatar' src="">
                    <ul id='menu_items'></ul>
                    <a href='/admin/logout' class='browserid_logout'><i class="icon-signout"></i>Logout</a>"""

    ui:
      items:  '#menu_items'
      avatar: '#user_avatar'

    add_item: (path, icon, title) ->
      @ui.items.append("""<li><a href="#/#{ path }"><i class="icon-#{ icon }"></i>#{ title }</a></li>""")

    events:
      'click a': 'item_clicked'

    item_clicked: (e) ->
      @select_item($(e.currentTarget))

    select_item: ($i) ->
      @$el.find('a.active').removeClass('active')
      $i.addClass('active')


  Module.addInitializer (options) ->
    layout = new Module.Main()
    App.layout = layout
    App.main   = layout.content

    # add main character layout to DOM
    $('body').prepend(layout.render().el)

    # set user avatar
    layout.menu.currentView.ui.avatar.attr('src', options.user.avatar_url)

    # add project logo
    $("<style>#logo{background-image:url('#{ options.logo }');}</style>").appendTo("head")

    # initialize foundation plugins
    $(document).foundation('topbar section forms dropdown')


  App.add_menu_item = (path, icon, title) ->
    App.layout.menu.currentView.add_item(path, icon, title)

  App.first_app_link = ->
    App.layout.menu.currentView.ui.items.find('a').attr('href')