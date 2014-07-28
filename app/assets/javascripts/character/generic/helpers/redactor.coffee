# ---------------------------------------------------------
# REDACTOR
# ---------------------------------------------------------

window.RedactorPlugins ||= {}

RedactorPlugins.gallery =
  init: ->
    @buttonAddBefore('video', 'image', 'Insert Images', @insertImages)

  insertImages: ->
    @selectionSave()
    chr.execute 'showImages', true, (images) =>
      _.each images.reverse(), (model) =>
        # HACK: this workaround sometimes Rails includes image mount_uploader
        image = model.get('image')
        image = image.image if image.image
        data = { filelink: image.regular.url, filename: '' }
        @imageInsert(data, false)
      @observeImages()

@Character.Generic.Helpers.startRedactor = ($content, redactorOptions) ->
  if $.fn.redactor
    $('#details_header').prepend "<div id='redactor_toolbar' class='chr-redactor-toolbar'></div>"
    options =
      formattingPre:  false
      convertLinks:   false
      cleanup:        false
      pastePlainText: true
      plugins: [ 'gallery' ]
      buttons: ['html', 'formatting', 'bold', 'italic', 'deleted', 'unorderedlist', 'orderedlist', 'outdent', 'indent', 'video', 'file', 'table', 'link', 'alignment', 'horizontalrule']
    # TODO: required default options are overriden by options.redactorOptions
    #       need to use something like customRedactorOptions
    _(options).extend(redactorOptions)
    $content.find('.character-redactor').redactor(options)

@Character.Generic.Helpers.stopRedactor = ($content) ->
  if $.fn.redactor
    $content.find('.character-redactor').redactor('destroy')
    $('#redactor_toolbar').remove()
