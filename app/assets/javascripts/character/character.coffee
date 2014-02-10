#= require_self
#= require_tree ./plugins
#= require ./modules/generic/module
#= require ./modules/settings/module
#= require ./modules/blog/module

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

@chr.commands.setHandler 'addMenuItem', (path, icon, title) ->
  $menuItems = $('#menu_items')
  $menuItems.append """<li>
                         <a href='#/#{ path }' class='chr-menu-item-#{ path }'>
                           <i class='chr-menu-icon fa fa-#{ icon }'></i>#{ title }
                         </a>
                       </li>"""

@chr.commands.setHandler 'showModule', (module) ->
  if chr.currentModuleName != module.moduleName
    chr.currentModuleName = module.moduleName

    name   = module.moduleName
    layout = module.layout

    $menuEl = $('#menu')
    $menuEl.find('a.active').removeClass('active')
    $menuEl.find("a.chr-menu-item-#{name}").addClass('active')

    chr.content.show(layout)
    $('#content').attr('class', "chr-content #{name}-module")


@chr.commands.setHandler 'showError', (response) ->
  Character.Utils.errorModal(response)

@chr.commands.setHandler 'startDetailsFormPlugins', ($form) ->
  Character.Utils.fixRailsDateSelect($form)
  Character.Utils.startImagesHelper($form)
  Character.Utils.startDrawerHelper($form)

@chr.commands.setHandler 'beforeFormSubmit', (ui) ->
  Character.Utils.serializeDataInputs(ui.content, ui.form)

@chr.commands.setHandler 'stopDetailsFormPlugins', ($form) ->
  Character.Utils.stopImagesHelper($form)
  Character.Utils.stopDrawerHelper($form)

@chr.on "initialize:before", (@options) ->

@chr.on "initialize:after", ->
  $('#error_modal').foundation('reveal')

  if Backbone.history
    Backbone.history.start()

  if location.hash == ''
    location.hash = $('#menu a:eq(0)').attr('href')