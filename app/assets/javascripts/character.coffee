#= require jquery
#= require jquery_ujs
#= require underscore
#= require underscore.string
#= require underscore.inflection
#= require backbone
#= require backbone.marionette
#= require browserid
#= require new_character/character
#= require_self

#
# Module Helpers
#

chr.blogPosts = (opts) ->
  moduleOpts =
    menuIcon:     'quote-left'
    listItem:
      titleField: 'title'
      metaField:  'tagline'
    modelName:    'Character-Blog-Post'
    listSearch:   true
    listScopes:
      default:
        orderBy:  'published_at:desc'
      published:
        where:    'published=true'
        orderBy:  'published_at:desc'
      drafts:
        where:    'published=false'
        orderBy:  'published_at:desc'

  _(moduleOpts).extend(opts)

  chr.genericModule('Post', moduleOpts)

#
# Settings Helpers
#

chr.settingsAdmins = ->
  chr.settingsModule('Admins')

chr.settingsBlog = ->
  chr.settingsModule 'Blog Settings',
    titleMenu: 'Blog'

chr.settingsBlogCategories = ->
  chr.settingsModule 'Blog Categories',
    detailsViewClass: Character.Blog.CategoriesView