
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

  html = """<iframe srcdoc='#{ responseText }' style='position: relative; width:100%; border: none; height: 100%;'></iframe>"""
  $('#error_modal_content').html(html)

  $('#error_modal').foundation('reveal', 'open')