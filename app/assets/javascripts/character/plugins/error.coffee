
@Character.Utils ||= {}
@Character.Utils.error = (response) ->
  entityMap =
    '&': '&amp;'
    '<': '&lt;'
    '>': '&gt;'
    '"': '&quot;'
    "'": '&#39;'
    '/': '&#x2F;'
  escapeHtml = (string) -> String(string).replace(/[&<>"'\/]/g, (s) -> entityMap[s])
  responseText = escapeHtml(response.responseText)

  $('#error_message').html("""<iframe srcdoc='#{ responseText }'></iframe>""")
  window.showErrorOverlay()


$ ->
  $container = $('#character')
  $overlay   = $('#error')
  $closeBttn = $('#error_close')

  window.showErrorOverlay = ->
    $overlay.addClass('open')
    $container.addClass('error-open')

  window.hideErrorOverlay = ->
    $overlay.removeClass('open')
    $container.removeClass('error-open')

  $closeBttn.on 'click', -> window.hideErrorOverlay()