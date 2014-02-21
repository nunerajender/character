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

@newSettingsItem = ($input, $list) ->
  $item = $('#template').clone()
  $item.removeAttr('id')
  $item.html $item.html().replace(/objects\[\]\[\]/g, "objects[][#{ new Date().getTime() }]")

  if $list.length then $list.append($item) else $('#template').before($item)

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
  $list = $content.find('.sortable-list')

  $('.objects_title input').on 'keyup', (e) ->
    if e.which == 13
      newSettingsItem($(e.currentTarget), $list)

  options =
    delay:  150
    items:  '> .category'
    handle: '.action_sort'
    update: (e, ui) =>
      # TODO: seems like this could be done much simpler with regex
      positionFields = _.select $list.find("input[type=hidden]"), (f) ->
        _( $(f).attr('name') ).endsWith('[_position]')
      _.each positionFields, (el, index, list) ->
        $(el).val(positionFields.length - index)

  $list.sortable(options).disableSelection()

$(document).on 'chr-blog_categories-details-content.closed', (e, $content) ->
  $('.objects_title input').off 'keyup'
  $list = $content.find('.sortable-list')
  if $list.length
    $list.sortable( "destroy" )