

@CharacterMenu = Backbone.Marionette.ItemView.extend
  tagName:   'nav'
  id:        'menu'
  className: 'chr-menu'

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