@Character.Plugins ||= {}

@Character.Plugins.imagesHelperReorderable = () ->
  $list = $('#images_helper')
  if $list.hasClass('reorderable')
    sort_options =
      handle: '.handle'
      stop: (e, ui) ->
        items = $list.find('.fields')
        total = items.length
        items.each (index, el) ->
          $(el).find('.hidden.position').val(total - index)

    $list.sortable(sort_options).disableSelection()

  $list.on 'click', '.action-edit-title', (e) ->
    e.preventDefault()
    $title_input = $(e.currentTarget).parent().find('.hidden.title')
    val     = $title_input.val()
    new_val = prompt("Enter new title for image", val)
    if new_val or new_val == ''
      $title_input.val(new_val)