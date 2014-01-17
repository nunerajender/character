#= require jquery
#= require browserid
#= require jquery_ujs
#= require jquery.form
#= require jquery_nested_form
#= require jquery.autosize
#= require underscore
#= require underscore.string
#= require underscore.inflection
#= require backbone
#= require backbone.marionette
#= require moment

#= require_self

#= require_tree ./plugins
#= require_tree ./app


_.mixin(_.str.exports())


#
# Marionette.js Application Documentation
# https://github.com/marionettejs/backbone.marionette/blob/master/docs/marionette.application.md
#
@chr = new Backbone.Marionette.Application()

@chr.addRegions
  menu:    '#menu'
  content: '#content'

@chr.commands.setHandler 'addMenuItem', (path, icon, title) ->
  @ui.items.append """<li>
                        <a href='#/#{ path }' class='chr-menu-item-#{ path }'>
                          <i class='fa fa-#{ icon }'></i>#{ title }
                        </a>
                      </li>"""

@chr.commands.setHandler 'selectMenuItem', (item_class) ->
  $menu_el = $('#menu')
  $menu_el.find('a.active').removeClass('active')
  $menu_el.find("a.chr-menu-item-#{item_class}").addClass('active')

@chr.commands.setHandler 'showContentView', (view) ->
  chr.getRegion('content').show(view)

@chr.on "initialize:before", (@options) ->

@chr.on "initialize:after", ->
  if Backbone.history
    Backbone.history.start()

  # this should be done via signal
  # if location.hash == ""
  #   location.hash = @menu.firstItem().attr('href')




# TODO:
# Move this to details view for generic app
$ ->
  $(document).on 'rendered.chrForm', (e, $form) ->
    Character.Plugins.fix_date_field_layout()
    Character.Plugins.enableDrawers()
    Character.Plugins.imagesHelperReorderable()



#
  # main_view = new Character.MainView()
  # main_view.render().$el.prependTo('body')

  # @main = main_view.content
  # @menu = main_view.menu.currentView

  # set user avatar
  #@menu.ui.avatar.attr('src', options.user.avatar_url)

  # add project logo
  #$("<style>.logo{background-image:url('#{ options.logo }');}</style>").appendTo("head")

  # initialize foundation plugins
  #$(document).foundation()


@Character ||= {}

#========================================================
# Menu
#========================================================
# @Character.MenuView = Backbone.Marionette.ItemView.extend
#   tagName: 'nav'

#   template: -> """<img id='user_avatar' src="">
#                   <ul id='menu_items'></ul>
#                   <a href='' class='browserid_logout'><i class="fa fa-sign-out"></i>Sign out</a>"""

#   ui:
#     items:          '#menu_items'
#     avatar:         '#user_avatar'
#     action_logout:  '.browserid_logout'

#   addItem: (path, icon, title) ->
#

#   selectItem: (cls) ->
#     @$el.find('a.active').removeClass('active')
#     @$el.find("a.mi-#{cls}").addClass('active')

#   firstItem: ->
#     @ui.items.find('a:eq(0)')

#   onRender: ->
#     @ui.action_logout.attr 'href', chr.options.url + '/logout'