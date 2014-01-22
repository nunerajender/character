# Author: Alexander Kravets
# Slate Studio 2013

# This plugin depends on:
#  - jquery
#  - underscore
#  - underscore.string

@Character.Utils ||= {}
@Character.Utils.fixRailsDateSelect = ($form)->
  setDateValue = ($dateElement, $hiddenDateField) ->
    day   = $( $dateElement.find('select')[0] ).val()
    month = $( $dateElement.find('select')[1] ).val()
    year  = $( $dateElement.find('select')[2] ).val()
    dateValue = "#{year}-#{month}-#{day}"
    $hiddenDateField.attr('value', dateValue)

  $form.find('.row.chr-date-dmy').each (date_el_index, date_el) ->

    # insert hidden field for date
    dateFieldName = $(date_el).find('select').first().attr('name')
      .replace('(3i)', '')
      .replace('(2i)', '')
      .replace('(1i)', '')

    $(date_el).append("<input type='hidden' name='#{ dateFieldName }' />")
    $dateFieldInput = $(date_el).find('input[type="hidden"]').first()

    # wrap date input elements into Foundation grid and attach events
    $(date_el).find('select').each (select_el_index, select_el) ->
      $(select_el).wrap("<div class='small-#{ 4 } columns chr-date-day' />")
      $(select_el).on 'change', -> setDateValue( $(date_el), $dateFieldInput )
      setDateValue( $(date_el), $dateFieldInput )