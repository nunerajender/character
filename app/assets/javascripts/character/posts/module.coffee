# ---------------------------------------------------------
# POSTS
# ---------------------------------------------------------

@Character.Posts = {}

#
# Marionette.js Layout Documentation
# https://github.com/marionettejs/backbone.marionette/blob/master/docs/marionette.itemview.md
# character/generic/details.coffee
@Character.Posts.DetailsLayout = Character.Generic.DetailsLayout.extend
  setBackgroundImage: (imageUrl) ->
    @ui.featuredImageUploader.addClass('has-image')
    @ui.featuredImageUploader.css({ 'background-image': "url(#{ imageUrl })" })

  updateFeaturedImage: (imageData) ->
    imageUrl = imageData.image.regular.url
    thumbUrl = imageData.image.chr_thumb_small.url
    @ui.featuredImageInput.val(imageUrl)
    @ui.featuredThumbInput.val(thumbUrl)
    @setBackgroundImage(imageUrl)

  getSubtitleValue: ->
    # TODO: add case when image is posted first or nothing is posted
    @ui.postContent.children().first().text()

  _bindSubtitleUpdate: ->
    # update subtitle to be first passage of the body text
    @ui.subtitleField.val(@getSubtitleValue())
    @ui.postContent.on 'keyup', => @ui.subtitleField.val(@getSubtitleValue())

  _hideForm: ->
    if @ui.form.parent().hasClass 'chr-form-scrolled-up'
      editableAreaHeight = $(window).height() - 71 - @ui.featuredImageUploader.outerHeight(true)
      @ui.post.css { 'min-height': editableAreaHeight }
      @ui.content.scrollTop @ui.form.parent().outerHeight(true)

  _bindFeaturedImageUploader: ->
    imageUrl = @ui.featuredImageUploader.attr('data-image-url')
    if imageUrl and imageUrl != ''
      @setBackgroundImage(imageUrl)

    @ui.featuredImageUploader.on 'click', (e) =>
      chr.execute 'showImages', false, (images) =>
        model = images[0]
        if model
          @updateFeaturedImage(model.get('image'))

  afterRenderContent: ->
    @ui.featuredImageUploader = $('#character_post_featured_image_uploader')
    @ui.featuredImageInput    = $('#character_post_featured_image_url')
    @ui.featuredThumbInput    = $('#character_post_featured_image_chr_thumbnail_url')
    @ui.publishedCheckbox     = $('#character_post_published')
    @ui.subtitleField         = $('#character_post_subtitle')
    @ui.post                  = @ui.content.find('.posts-show')
    @ui.postContent           = @ui.post.find('.content')

    @_hideForm()
    @_bindSubtitleUpdate()
    @_bindFeaturedImageUploader()

  afterOnClose: ->
    @ui.postContent.off 'keyup'
    @ui.featuredImageUploader.off('click')


chr.postsModule = (opts) ->
  moduleOpts =
    implementation: Character.Posts
    menuIcon:       'rss'
    menuTitle:      'Posts'
    listItem:
      titleField:   'title'
      metaField:    'updated_ago'
      thumbField:   'chr_featured_thumbnail_url'
    modelName:      'Character-Post'
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