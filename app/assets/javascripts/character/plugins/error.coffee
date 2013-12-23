@Character.Plugins.parseError = (response, callback) ->
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
  html = """<iframe srcdoc='#{ responseText }' style='position: absolute; top: 0; right: 0; left: 0; bottom: 0; border: none; width: 100%; height: 100%;'></iframe>"""
  callback(html)