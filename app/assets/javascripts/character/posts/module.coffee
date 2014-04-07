# ---------------------------------------------------------
# POSTS
# ---------------------------------------------------------

@Character.Posts = {}

#
# Marionette.js Layout Documentation
# https://github.com/marionettejs/backbone.marionette/blob/master/docs/marionette.itemview.md
# character/generic/details.coffee
@Character.Posts.DetailsLayout = Character.Generic.DetailsLayout.extend
  _setBackgroundImage: (imageUrl) ->
    @ui.featuredImageUploader.addClass('has-image')
    @ui.featuredImageUploader.css({ 'background-image': "url(#{ imageUrl })" })

  _updateFeaturedImage: (image) ->
    imageUrl = image.regular.url
    thumbUrl = image.chr_thumb_small.url
    @ui.featuredImageInput.val(imageUrl)
    @ui.featuredThumbInput.val(thumbUrl)
    @_setBackgroundImage(imageUrl)

  _getSubtitleValue: ->
    # TODO: add case when image is posted first or nothing is posted
    @ui.postContent.children().first().text()

  _bindSubtitleUpdate: ->
    # update subtitle to be first passage of the body text
    @ui.subtitleField.val(@_getSubtitleValue())
    @ui.postContent.on 'keyup', => @ui.subtitleField.val(@_getSubtitleValue())

  _hideForm: ->
    if @ui.form.parent().hasClass 'chr-form-scrolled-up'
      editableAreaHeight = $(window).height() - 71 - @ui.featuredImageUploader.outerHeight(true)
      @ui.post.css { 'min-height': editableAreaHeight }
      @ui.content.scrollTop @ui.form.parent().outerHeight(true)

  _removeFeaturedImage: ->
    @ui.featuredImageInput.val('')
    @ui.featuredThumbInput.val('')
    @ui.featuredImageUploader.removeClass('has-image').css({ 'background-image': "" })

  _bindRemove: ->
    @ui.removeButton = $("<i class='remove fa fa-trash-o'></i>")
    @ui.removeButton.appendTo(@ui.featuredImageUploader)
    @ui.removeButton.on 'click', (e) => @_removeFeaturedImage() ; false

  _bindFeaturedImageUploader: ->
    imageUrl = @ui.featuredImageUploader.attr('data-image-url')
    if imageUrl and imageUrl != ''
      @_setBackgroundImage(imageUrl)

    @ui.featuredImageUploader.on 'click', (e) =>
      @ui.featuredImageUploader.addClass 'select'
      chr.execute 'showImages', false, (images) =>
        if images.length > 0
          model = images[0]
          if model
            @_updateFeaturedImage(model.get('image'))

        @ui.featuredImageUploader.removeClass 'select'

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
    @_bindRemove()

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
    redactorOptions:
      toolbarFixed:          true
      toolbarFixedTarget:    '#details_content'
      toolbarFixedTopOffset: -110
      initCallback:          -> $('.redactor_character-redactor').attr('data-input-name', 'character_post[body_html]')

  _(moduleOpts).extend(opts)

  chr.genericModule('Post', moduleOpts)