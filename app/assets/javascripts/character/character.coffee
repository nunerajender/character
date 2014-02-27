#= require_self
#= require ./generic/module
#= require ./settings/module
#= require ./blog/module
#= require ./images/module

@Character ||= {}

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

API =
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

  showError: (response) ->
    $container = $('#character')
    $overlay   = $('#chr_error')

    if $overlay.length == 0
      $container.after """<div id='chr_error' class='chr-error'>
                            <div id='chr_error_message' class='chr-error-message'></div>
                            <button id='chr_error_close' type='button' class='chr-error-close'>
                              <i class='chr-icon icon-close'></i>
                            </button>
                          </div>"""
      $overlay = $('#chr_error')

    entityMap = { '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;', '/': '&#x2F;' }
    escapeHtml = (string) -> String(string).replace(/[&<>"'\/]/g, (s) -> entityMap[s])
    responseText = escapeHtml(response.responseText)

    $('#chr_error_message').html """<iframe srcdoc='#{ responseText }'></iframe>"""
    $('#chr_error_close').on 'click', -> chr.execute('closeError')

    $overlay.addClass('open')
    $container.addClass('error-open')

  closeError: ->
    $('#chr_error').removeClass('open')
    $('#character').removeClass('error-open')
    $('#chr_error_close').off 'click'

  closeDetailsView: ->
    Backbone.history.navigate('#/' + chr.currentPath, { trigger: true })


_.map API, (method, name) => @chr.commands.setHandler(name, method)


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
      if $('#chr_images').hasClass 'open'
        chr.execute('closeImages')

      else if $('#chr_error').hasClass 'open'
        chr.execute('closeError')

      else
        chr.execute('closeDetailsView')