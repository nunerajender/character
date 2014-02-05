#= require_self
#= require ./categories

@Character.Blog ||= {}

# update subtitle value when blog post body changes
$ ->
  getSubtitleValue = ->
    $('.chr-blog-post-body p').first().text()

  $(document).on 'chr-posts-details-content.rendered', (e, $content) ->
    $subtitleField = $('#character_blog_post_subtitle')
    $subtitleField.val(getSubtitleValue())

    $('.chr-blog-post-body').on 'keyup', -> $subtitleField.val(getSubtitleValue())

  $(document).on 'chr-posts-details-content.closed', (e, $content) ->
    $('.chr-blog-post-body').off 'keyup'