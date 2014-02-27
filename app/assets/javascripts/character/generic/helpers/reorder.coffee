# ---------------------------------------------------------
# REORDER LIST ITEMS
# ---------------------------------------------------------

@Character.Generic.Plugins.stopReorder = (el) ->
  el.sortable( "destroy" )

@Character.Generic.Plugins.startReorder = (el, collection) ->
  updateModelPosition = ($el, position) ->
    object_id = $el.attr('data-id')
    object    = collection.get(object_id)
    object.save({ _position: position }, { patch: true })

  options =
    delay: 150
    placeholder: 'placeholder'
    update: (e, ui) =>
      prev = ui.item.prev()
      next = ui.item.next()

      if prev.length > 0 and next.length > 0
        prevPosition = parseFloat prev.attr('data-position')
        nextPosition = parseFloat next.attr('data-position')
        newPosition  = (prevPosition + nextPosition) / 2

      else if prev.length > 0 # bottom of the list
        lastPosition = parseFloat prev.attr('data-position')
        newPosition  = lastPosition - 10

      else if next.length > 0 # top of the list
        firstPosition = parseFloat next.attr('data-position')
        newPosition   = firstPosition + 10

      updateModelPosition(ui.item, newPosition)

  el.sortable(options).disableSelection()