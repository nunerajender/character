
@Character.Utils ||= {}
@Character.Utils.startAutosizeTextarea = ($form) ->
  $form.find('textarea.autosize').autosize()

@Character.Utils.stopAutosizeTextarea = ($form) ->
  $form.find('textarea.autosize').trigger('autosize.destroy')