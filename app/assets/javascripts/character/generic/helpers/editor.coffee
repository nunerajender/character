# ---------------------------------------------------------
# EDITOR
# ---------------------------------------------------------

$ ->
  $(document).on 'chr-details-content.rendered', (e, $content) ->
    $('.character-editor').editor { viewSelector: '#details_content' }

  $(document).on 'chr-details-content.closed', (e, $content) ->
    $('.character-editor').each (i, el) -> $(el).data('editor').destroy()