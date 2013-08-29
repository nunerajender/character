#= require_tree ./templates
#= require_tree ./views
#= require_self

class @Character extends Backbone.Marionette.Application
  render: ->
    @layout = new CharacterLayout().render()
    $('body').html(@layout.el)
    @ui = @layout.ui


  initialize_plugins: ->
    $(document).foundation('topbar section forms')


  update_user_image: ->
    @ui.user_image.attr('src', window.user_image_url)


  add_menu_item: (title, scope, icon) ->
    html = """<li>
                <a href="#/#{ scope }">
                  <i class="icon-#{ icon }"></i>#{ title }
                </a>
              </li>
              <li class="divider"></li>"""
    @ui.top_menu.append(html)


  add_menu_items: ->
    _.each @submodules, (m) =>
      # skip settings module
      if m.moduleName != 'Settings'
        @add_menu_item(m.options.pluralized_name, m.options.scope, m.options.icon)

    @layout.select_menu_item(@layout.scope)


  jump_to_first_app: ->
    if window.location.hash == ""
      path = $('#menu .top-bar-section .left li a:eq(0)').attr 'href'
      window.location.hash = path

