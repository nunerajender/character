#= require_self
#= require_tree ./plugins
#= require ./modules/generic/module
#= require ./modules/settings/module
#= require ./modules/blog/module
#= require ./modules/images/module

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

@chr.on "initialize:before", (@options) -> # maps options!

@chr.on "initialize:after", ->
  if Backbone.history
    Backbone.history.start()

  if location.hash == ''
    location.hash = $('#menu a:eq(1)').attr('href')

  $(document).bind 'drop dragover', (e) -> e.preventDefault()

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

  beforeFormSubmit: (ui) ->
    Character.Plugins.serializeDataInputs(ui.content, ui.form)

  startFormPlugins: ($form) ->
    Character.Plugins.startDateSelect($form)
    Character.Plugins.startDrawerHelper($form)

  stopFormPlugins: ($form) ->
    Character.Plugins.stopDateSelect($form)
    Character.Plugins.stopDrawerHelper($form)

_.map characterApi, (method, name) => @chr.commands.setHandler(name, method)