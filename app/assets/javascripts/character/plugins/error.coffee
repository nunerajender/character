# ---------------------------------------------------------
# ERROR
# ---------------------------------------------------------

@Character.Plugins.error = (response) ->
  entityMap = { '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;', '/': '&#x2F;' }
  escapeHtml = (string) -> String(string).replace(/[&<>"'\/]/g, (s) -> entityMap[s])
  responseText = escapeHtml(response.responseText)

  $('#chr_error_message').html("""<iframe srcdoc='#{ responseText }'></iframe>""")
  window.showErrorOverlay()

$ ->
  $container = $('#character')

  $container.after """<div id='chr_error' class='chr-error'>
                        <div id='chr_error_message' class='chr-error-message'></div>
                        <button id='chr_error_close' type='button' class='chr-error-close'><i class='chr-icon icon-close'></i></button>
                      </div>"""

  $overlay   = $('#chr_error')
  $closeBttn = $('#chr_error_close')

  window.showErrorOverlay = ->
    $overlay.addClass('open')
    $container.addClass('error-open')

  window.hideErrorOverlay = ->
    $overlay.removeClass('open')
    $container.removeClass('error-open')

  $closeBttn.on 'click', window.hideErrorOverlay