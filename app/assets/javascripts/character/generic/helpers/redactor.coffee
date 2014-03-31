# ---------------------------------------------------------
# REDACTOR
# ---------------------------------------------------------

@Character.Generic.Helpers.startRedactor = ($content, editorOptions) ->
  if $.fn.redactor
    options = { viewSelector: '#details_content' }
    _(options).extend(editorOptions)
    $content.find('.character-redactor').redactor()

@Character.Generic.Helpers.stopRedactor = ($content) ->
  if $.fn.redactor
    $content.find('.character-redactor').redactor('destroy')