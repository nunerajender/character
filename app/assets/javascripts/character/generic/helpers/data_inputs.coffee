# ---------------------------------------------------------
# SERIALIZE INPUTS
# ---------------------------------------------------------

@Character.Generic.Helpers.serializeDataInputs = ($content, $form) ->
  if $content and $form
    $content.find('[data-input-name]').each (i, el) ->
      dataInputName = $(el).attr('data-input-name')
      if dataInputName
        if $(el).hasClass('character-editor')
          value = $(el).data('editor').serialize()
        else
          value = $(el).html().trim()

        $hiddenInput = $form.find("input[name='#{ dataInputName }']")

        if $hiddenInput.length == 0
          $hiddenInput = $("<input type='hidden' name='#{ dataInputName }'>")
          $hiddenInput.appendTo($form)

        $hiddenInput.val(value)