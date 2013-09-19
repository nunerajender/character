

class @CharacterApplicationMenu extends Backbone.Marionette.Layout
  tagName:   'nav'
  id:        'menu'
  className: 'chr-menu'

  template: -> """<img id='user_avatar' src="">
                  <ul id='menu_items'>
                    <li><a href="#/dashboard" class='active'><i class="icon-dashboard"></i>Dashboard</a></li>
                    <li><a href="#/dashboard"><i class="icon-rocket"></i>Dashboard</a></li>
                  </ul>
                  <a href='/admin/logout' class='browserid_logout'><i class="icon-signout"></i>Logout</a>"""

  ui:
    items: '#menu_items'

  add_app: (path, icon, title) ->
    @ui.items.append("""<li><a href="#/#{ path }"><i class="icon-#{ icon }"></i>#{ title }</a></li>""")

  events:
    'click a': 'item_clicked'

  item_clicked: (e) ->
    @select_item($(e.currentTarget))

  select_item: ($i) ->
    @ui.items.find('a.active').removeClass('active')
    $i.addClass('active')