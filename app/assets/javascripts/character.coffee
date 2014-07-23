#= require jquery
#= require jquery_ujs
#= require jquery.form
#= require jquery-ui/sortable
#= require jquery-ui/widget
#= require jquery.iframe-transport
#= require jquery.fileupload
#= require jquery_nested_form

#= require underscore
#= require underscore.string
#= require underscore.inflection
#= require backbone
#= require backbone.marionette

#= require moment
#= require character_editor
#= require redactor

#= require_self
#= require ./character/generic/module
#= require ./character/settings/module
#= require ./character/posts/module
#= require ./character/images/module
#= require ./character/pages/module
#= require ./character/dashboard/module

# Safari detection for CSS workarounds

$ ->
  ua = navigator.userAgent.toLowerCase()
  if ua.indexOf('safari') != -1
    unless ua.indexOf('chrome') > -1
      $('body').addClass 'safari'

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
                           <a href='#/#{ path }' class='chr-menu-item-#{ path }' title='#{ title }'>
                             <i class='chr-menu-icon fa fa-#{ icon }'></i><div class='chr-menu-title'>#{ title }</div>
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

      chr.content.show(layout, { preventDestroy: true })

      $('#content').attr('class', "chr-content #{name}")

  closeDetailsView: ->
    Backbone.history.navigate('#/' + chr.currentPath, { trigger: true })

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

    $('#chr_error_message').html "<pre>#{ responseText }</pre>"
    $('#chr_error_close').on 'click', -> chr.execute('closeError')

    $overlay.addClass('open')
    $container.addClass('error-open')

  closeError: ->
    $('#chr_error').removeClass('open')
    $('#character').removeClass('error-open')
    $('#chr_error_close').off 'click'

_.map API, (method, name) => @chr.commands.setHandler(name, method)


@chr.on "before:start", (@options) -> # maps options!
  # shortcuts
  window.shortcuts = new window.keypress.Listener()

  # close dialogs and details view on esc
  window.shortcuts.register_combo
    keys: 'esc'
    is_exclusive: true
    on_keyup: (event) ->
      if $('#chr_images').hasClass 'open'
        chr.execute('hideImages')
      else if $('#chr_error').hasClass 'open'
        chr.execute('closeError')
      else
        chr.execute('closeDetailsView')


@chr.on "start", ->
  # start history
  if Backbone.history
    Backbone.history.start()

  # jump to first menu item when login to admin
  if location.hash == ''
    location.hash = $('#menu a:eq(1)').attr('href')

  # disable default action for browser when drop image to window
  $(document).bind 'drop dragover', (e) -> e.preventDefault()