#= require_self
#= require ./layout
#= require ./details

@Character.Settings ||= {}

#
# Marionette.js Module Documentation
# https://github.com/marionettejs/backbone.marionette/blob/master/docs/marionette.application.module.md
#
chr.module 'settings', (module) ->
  module.addInitializer ->
    @layout     = new Character.Settings.Layout({ module: @ })
    @controller = new Character.Settings.Controller({ module: @ })
    @router     = new Character.Settings.Router({ controller: @controller })

#
# Marionette.js Router Documentation
# https://github.com/marionettejs/backbone.marionette/blob/master/docs/marionette.approuter.md
#
@Character.Settings.Router = Backbone.Marionette.AppRouter.extend
  appRoutes:
    'settings': 'index'
    'settings/:settingsModuleName': 'edit'

#
# Marionette.js Controller Documentation
# https://github.com/marionettejs/backbone.marionette/blob/master/docs/marionette.controller.md
#
@Character.Settings.Controller = Marionette.Controller.extend
  initialize: ->
    @module = @options.module

  index: ->
    chr.execute('showModule', @module)
    chr.currentPath = "settings"

  edit: (settingsModuleName) ->
    @index()

    options = @module.submodules[settingsModuleName].options
    detailsView = new options.detailsViewClass(options)

    @module.layout.details.show(detailsView)
    @module.layout.setActiveMenuItem(settingsModuleName)

#
# Character Settings Module
# Initialize function
#
chr.settingsModule = (title, options={}) ->
  options.titleMenu    ?= title
  options.titleDetails ?= title
  options.moduleName   ?= _.underscored(title)

  options.detailsViewClass ?= Character.Settings.DetailsView

  chr.module "settings.#{options.moduleName}", ->
    @options = options


#
# Helpers
#

@newSettingsItem = ($input) ->
  $item = $('#template').clone()
  $item.removeAttr('id')
  $item.html $item.html().replace(/objects\[\]\[\]/g, "objects[][#{ new Date().getTime() }]")
  $('#template').before($item)
  $item.find('input').val($input.val())
  $item.find('.fa-plus').hide()
  $item.find('.action_delete').show()
  $item.find('.action_sort').show()
  $input.val('')

#
# Admin Settings
# Feature: add new admin list item
#

$(document).on 'chr-admins-details-content.rendered', (e, $content) ->
  $('.objects_email input').on 'keyup', (e) ->
    if e.which == 13
      newSettingsItem($(e.currentTarget))

$(document).on 'chr-admins-details-content.closed', (e, $content) ->
  $('.objects_email input').off 'keyup'

#
# Categories Settings
# Feature: add new category list item & reorder categories
#
$(document).on 'chr-blog_categories-details-content.rendered', (e, $content) ->
  $('.objects_title input').on 'keyup', (e) ->
    if e.which == 13
      newSettingsItem($(e.currentTarget))

  options =
    delay:  150
    items:  '> .category'
    handle: '.action_sort'
    update: (e, ui) =>
      # position_fields = _.select @ui.form.find("input[type=hidden]"), (f) ->
      # _( $(f).attr('name') ).endsWith('[_position]')
      # total_elements = position_fields.length
      # _.each position_fields, (el, index, list) -> $(el).val(total_elements - index)
  $content.find('form').sortable(options).disableSelection()

$(document).on 'chr-blog_categories-details-content.closed', (e, $content) ->
  $('.objects_title input').off 'keyup'
  $content.find('form').sortable( "destroy" )