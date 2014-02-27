
chr.blogPosts = (opts) ->
  moduleOpts =
    menuIcon:       'rss'
    menuTitle:      'Posts'
    listItem:
      titleField:   'title'
      metaField:    'updated_ago'
      thumbField:   'chr_featured_thumbnail_url'
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
      # auto scroll to hide secondary info
      $detailsView = $('#details_content')
      $content.find('.blog-post').css { 'min-height': $detailsView.height() - 84 - 66 }
      $detailsView.scrollTop(153)

      # update subtitle to be first passage of the body text
      $subtitleField = $('#character_blog_post_subtitle')
      $subtitleField.val(getSubtitleValue())
      $('.chr-blog-post-body').on 'keyup', ->
        $subtitleField.val(getSubtitleValue())

      # when new post or post not yet published show fullscreen mode
      if not $content.parent().hasClass 'update'
        $('#details').addClass('fullscreen')

      # featured image upload
      $content.find('.character-image-upload').each (index, el) ->
        # check if data-image-url attribute set
        imageUrl = $(el).attr('data-image-url')
        if imageUrl != ''
          $(el).addClass('character-image').append("<img src='#{ imageUrl }' />")

        $(el).fileupload
          url: '/admin/Character-Image'
          paramName: 'character_image[image]'
          dataType:  'json'
          dropZone:  $(el)
          done: (e, data) ->
            imageUrl = data.result.image.image.url
            thumbUrl = data.result.image.image.chr_thumb_small.url

            $('#character_blog_post_featured_image_url').val(imageUrl)
            $('#character_blog_post_featured_image_chr_thumbnail_url').val(thumbUrl)

            $(el).find('img').remove()
            $(el).addClass('character-image').append("<img src='#{ imageUrl }' />")

    $(document).on 'chr-posts-details-content.closed', (e, $content) ->
      # disable subtitle update
      $('.chr-blog-post-body').off 'keyup'

      # disable fullscreen mode
      $('#details').removeClass('fullscreen')

      # featured image upload
      $content.find('.character-image-upload').fileupload('destroy')