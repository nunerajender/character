# ---------------------------------------------------------
# DATE SELECT (rails fix)
# ---------------------------------------------------------

@Character.Plugins.startDateSelect = ($form)->
  updateDateValue = ($wrapper, $input) ->
    selects = $wrapper.children('select')

    day   = $(selects[0]).val()
    month = $(selects[1]).val()
    year  = $(selects[2]).val()

    $input.val("#{ year }-#{ month }-#{ day }")


  # initialize hiddin input and start value
  $form.find('.chr-date-dmy').each (i, el) ->

    $el          = $(this)
    $hiddenInput = $el.children('input[type="hidden"]')

    if $hiddenInput.length == 0
      dateFieldName = $el.children('select').first()
        .attr('name').replace('(3i)', '')
        .replace('(2i)', '')
        .replace('(1i)', '')
      $hiddenInput = $("<input type='hidden' name='#{ dateFieldName }' />").appendTo($el)

    updateDateValue($el, $hiddenInput)


  # remove bad field names
  $form.find('.chr-date-dmy select').attr('name', '')


  # update date on select change
  $form.find('.chr-date-dmy select').on 'change', (e) ->
    $parentDiv   = $(this).parent()
    $hiddenInput = $parentDiv.children('input[type="hidden"]').first()

    updateDateValue($parentDiv, $hiddenInput)


@Character.Plugins.stopDateSelect = ($form) ->
  $form.find('.chr-date-dmy select').off 'change'