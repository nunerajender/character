#= require jquery
#= require jquery_ujs
#= require jquery.form
#= require jquery.ui.sortable
#= require jquery_nested_form

#= require underscore
#= require underscore.string
#= require underscore.inflection
#= require backbone
#= require backbone.marionette

#= require moment
#= require browserid
#= require character_editor

#= require character/character


#
# Module Helpers
#


chr.flatPages = (opts) ->
  moduleOpts =
    menuIcon:     'edit'
    menuTitle:    'Pages'
    modelName:    'Character-FlatPage'
    listReorder:  true
    listItem:
      titleField: 'title'
      metaField:  'updated_ago'
  _(moduleOpts).extend(opts)

  chr.genericModule('Page', moduleOpts)


#
# Settings Helpers
#

chr.settingsAdmins = ->
  chr.settingsModule('Admins')

chr.settingsBlog = (titleMenu = 'Blog') ->
  chr.settingsModule 'Blog Settings',
    titleMenu: titleMenu

chr.settingsBlogCategories = (titleMenu = 'Categories') ->
  chr.settingsModule 'Blog Categories',
    titleMenu: titleMenu