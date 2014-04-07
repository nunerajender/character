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
        data = { filelink: model.get('image').regular.url, filename: '' }
        @imageInsert(data, false)
      @observeImages()

@Character.Generic.Helpers.startRedactor = ($content, redactorOptions) ->
  if $.fn.redactor
    options =
      plugins: [ 'gallery' ]
      buttons: ['html', 'formatting', 'bold', 'italic', 'deleted', 'unorderedlist', 'orderedlist', 'outdent', 'indent', 'video', 'file', 'table', 'link', 'alignment', 'horizontalrule']
    _(options).extend(redactorOptions)
    $content.find('.character-redactor').redactor(options)

@Character.Generic.Helpers.stopRedactor = ($content) ->
  if $.fn.redactor
    $content.find('.character-redactor').redactor('destroy')