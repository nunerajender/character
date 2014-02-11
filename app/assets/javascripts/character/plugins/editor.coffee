
$ ->
  $(document).on 'chr-details-content.rendered', (e, $content) ->
    $('.character-editor').editor
      buttons: 'bold, italic, underline, strikethrough, superscript, subscript, anchor, image, quote, orderedlist, unorderedlist, pre, header1, header2'
      viewSelector: '#details_content'

  $(document).on 'chr-details-content.closed', (e, $content) ->
    $('.character-editor').each (i, el) ->
      $(el).data('editor').destroy()