#= require jquery
#= require jquery_ujs
#= require underscore
#= require underscore.string
#= require backbone
#= require backbone.marionette
#= require browserid
#= require jquery.ui.sortable
#= require new_character/character
#= require_self

#
# Module Helpers
#

chr.blogPosts = (opts) ->
  module_opts =
    icon:                   'quote-left'
    item_title:             'title'
    item_meta:              'tagline'
    collection_url:         "/admin/Character-Blog-Post"
    search:                 true
    default_scope_order_by: 'published_at:desc'
    scopes:
      published:
        where:              'published=true'
        order_by:           'published_at:desc'
      drafts:
        where:              'published=false'
        order_by:           'published_at:desc'

  _(module_opts).extend(opts)

  chr.genericModule('Post', module_opts)

#
# Settings Helpers
#

chr.settingsAdmins = ->
  chr.settingsModule('Admins')

chr.settingsBlog = ->
  chr.settingsModule('Blog Settings')

chr.settingsPostCategories = ->
  chr.settingsModule 'Post Categories',
    detailsViewClass: Character.Blog.CategoriesView