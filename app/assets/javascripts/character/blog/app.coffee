

@CharacterBlogCategories = ->
  CharacterSettingsApp 'Blog Categories',
    detailsViewClass: Character.BlogCategories.DetailsView


@CharacterBlogPosts = (opts) ->
  app_opts =
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

  _(app_opts).extend(opts)
  CharacterApp('Post', app_opts)