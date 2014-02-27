#= require_self
#= require_tree ./plugins
#= require ./generic/module
#= require ./settings/module
#= require ./blog/module
#= require ./images/module

@Character ||= {}
@Character.Plugins ||= {}

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

# App Layout
# /app/views/character.html.erb
@chr.addRegions
  menu:    '#menu'
  content: '#content'

characterApi =
  addMenuItem: (path, icon, title) ->
    $menuItems = $('#menu_items')
    $menuItems.append """<li>
                           <a href='#/#{ path }' class='chr-menu-item-#{ path }'>
                             <i class='chr-menu-icon fa fa-#{ icon }'></i>#{ title }
                           </a>
                         </li>"""

  showModule: (module) ->
    if chr.currentModuleName != module.moduleName
      chr.currentModuleName = module.moduleName

      name   = module.moduleName
      layout = module.layout

      $menuEl = $('#menu')
      $menuEl.find('a.active').removeClass('active')
      $menuEl.find("a.chr-menu-item-#{name}").addClass('active')

      chr.content.show(layout)
      $('#content').attr('class', "chr-content #{name}")

  error: (response) ->
    Character.Plugins.error(response)

_.map characterApi, (method, name) => @chr.commands.setHandler(name, method)


@chr.on "initialize:before", (@options) -> # maps options!


@chr.on "initialize:after", ->
  # start history
  if Backbone.history
    Backbone.history.start()

  # jump to first menu item when login to admin
  if location.hash == ''
    location.hash = $('#menu a:eq(1)').attr('href')

  # disable default action for browser when drop image to window
  $(document).bind 'drop dragover', (e) -> e.preventDefault()

  # hotkeys
  $(document).on 'keyup', (e) ->
    # ESC
    if e.keyCode == 27
      # close images dialog
      if $('#chr_images').hasClass 'open'
        window.hideImagesOverlay()

      # close error dialog
      else if $('#chr_error').hasClass 'open'
        window.hideErrorOverlay()

      # close details view
      else
        window.closeDetailsView?()