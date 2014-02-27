
@Character.Generic.Plugins.serializeDataInputs = ($content, $form) ->
  if $content and $form
    $content.find('[data-input-name]').each (i, el) ->
      dataInputName = $(el).attr('data-input-name')
      if dataInputName
        if $(el).hasClass('character-editor')
          value = $(el).data('editor').serialize()
        else
          value = $(el).html().trim()

        $hiddenInput = $form.find("input[name='#{ dataInputName }']")
        if $hiddenInput.length
          $hiddenInput.val(value)
        else
          $form.append("<input type='hidden' name='#{ dataInputName }' value='#{ value }' />")