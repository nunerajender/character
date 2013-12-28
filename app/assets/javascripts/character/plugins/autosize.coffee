$ ->
  $(document).on 'rendered.chrForm', (e, $form) ->
    $form.find('textarea.autosize').autosize()