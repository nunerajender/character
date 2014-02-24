
chr.blogPosts = (opts) ->
  moduleOpts =
    menuIcon:       'rss'
    menuTitle:      'Posts'
    listItem:
      titleField:   'title'
      metaField:    'updated_ago'
      thumbField:   'chr_thumbnail_url'
    modelName:      'Character-Blog-Post'
    listSearch:     true
    listScopes:
      default:
        orderBy:    'published_at:desc'
      published:
        where:      'published=true'
        orderBy:    'published_at:desc'
      drafts:
        where:      'published=false'
        orderBy:    'published_at:desc'

  _(moduleOpts).extend(opts)

  chr.genericModule('Post', moduleOpts)

  # update subtitle value when blog post body changes
  $ ->
    getSubtitleValue = ->
      # TODO: add case when image is posted first or nothing is posted
      $('.blog-post .content').children().first().text()

    $(document).on 'chr-posts-details-content.rendered', (e, $content) ->
      # update subtitle to be first passage of the body text
      $subtitleField = $('#character_blog_post_subtitle')
      $subtitleField.val(getSubtitleValue())
      $('.chr-blog-post-body').on 'keyup', ->
        $subtitleField.val(getSubtitleValue())

      # when new post or post not yet published show fullscreen mode
      if not $content.parent().hasClass 'update'
        $('#details').addClass('fullscreen')

    $(document).on 'chr-posts-details-content.closed', (e, $content) ->
      # disable subtitle update
      $('.chr-blog-post-body').off 'keyup'

      # disable fullscreen mode
      $('#details').removeClass('fullscreen')