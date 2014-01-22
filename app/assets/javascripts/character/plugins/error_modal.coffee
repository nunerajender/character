
@Character.Utils ||= {}
@Character.Utils.errorModal = (response) ->
  entityMap =
    '&': '&amp;'
    '<': '&lt;'
    '>': '&gt;'
    '"': '&quot;'
    "'": '&#39;'
    '/': '&#x2F;'
  escapeHtml = (string) ->
    String(string).replace(/[&<>"'\/]/g, (s) -> entityMap[s])
  responseText = escapeHtml(response.responseText)

  if $('#error_modal').length < 1
    html = """<div id="error_modal" class="reveal-modal" data-reveal style='height: 70%;'>
                <div id="error_model_content" style='height: 100%;'></div>
                <a class="close-reveal-modal">&#215;</a>
              </div>"""
    $('body').append(html)
    $('#error_modal').foundation('reveal')

  html = """<iframe srcdoc='#{ responseText }' style='position: relative; width:100%; border: none; height: 100%;'></iframe>"""
  $('#error_model_content').html(html)

  $('#error_modal').foundation('reveal', 'open')