# ---------------------------------------------------------
# REDACTOR
# ---------------------------------------------------------

@Character.Generic.Helpers.startRedactor = ($content, redactorOptions) ->
  if $.fn.redactor
    options = {}
    _(options).extend(redactorOptions)
    $content.find('.character-redactor').redactor(options)

@Character.Generic.Helpers.stopRedactor = ($content) ->
  if $.fn.redactor
    $content.find('.character-redactor').redactor('destroy')