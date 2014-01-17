#= require_self
#= require ./modules/settings/module
#= require ./modules/blog/module

_.mixin(_.str.exports())

#
# Unsuck Your Backbone
# https://speakerdeck.com/ammeep/unsuck-your-backbone
#

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

@Character ||= {}