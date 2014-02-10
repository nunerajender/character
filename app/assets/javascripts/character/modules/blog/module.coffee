#= require_self
#= require ./categories

@Character.Blog ||= {}

chr.blogPosts = (opts) ->
  moduleOpts =
    menuIcon:     'quote-left'
    menuTitle:    'Posts'
    listItem:
      titleField: 'title'
      metaField:  'updated_ago'
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

  # update subtitle value when blog post body changes
  $ ->
    getSubtitleValue = ->
      # TODO: add case when image is posted first or nothing is posted
      $('.chr-blog-post-body').children().first().text()

    $(document).on 'chr-posts-details-content.rendered', (e, $content) ->
      $subtitleField = $('#character_blog_post_subtitle')
      $subtitleField.val(getSubtitleValue())

      $('.chr-blog-post-body').on 'keyup', ->
        $subtitleField.val(getSubtitleValue())

    $(document).on 'chr-posts-details-content.closed', (e, $content) ->
      $('.chr-blog-post-body').off 'keyup'