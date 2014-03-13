# ---------------------------------------------------------
# EDITOR
# ---------------------------------------------------------

@Character.Generic.Helpers.startEditor = ($content, editorOptions) ->
  options = { viewSelector: '#details_content' }
  _(options).extend(editorOptions)
  $content.find('.character-editor').editor options

@Character.Generic.Helpers.stopEditor = ($content) ->
  $content.find('.character-editor').each (i, el) -> $(el).data('editor').destroy()