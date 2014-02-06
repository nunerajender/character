
$ ->
  $(document).on 'chr-generic-details-content.rendered', (e, $content) ->
    $('.character-editor').editor()

  $(document).on 'chr-generic-details-content.closed', (e, $content) ->
    $('.character-editor').each (i, el) ->
      $(el).data('editor').destroy()