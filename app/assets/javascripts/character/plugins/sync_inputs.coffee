
@Character.Utils ||= {}
@Character.Utils.syncInputs = ($form)->
  $elements = $form.find('[data-input-id]')
  $elements.each (index, el) ->
    inputId = $(el).attr('data-input-id')
    value   = $(el).html()
    $("##{inputId}").val(value)
