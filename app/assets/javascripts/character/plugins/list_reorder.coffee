

@Character.Plugins.disableListReorder = (el) ->
  el.sortable( "destroy" )

@Character.Plugins.enableListReorder = (el, collection) ->
  updateModelPosition = ($el, position) ->
    id    = $el.attr 'data-id'
    model = collection.get(id)

    model.save({ _position: position }, { patch: true })

  options =
    delay:       150
    placeholder: 'placeholder'

    # NOTE: when all items have same position, e.g. 0 -> nothing happens
    update: (e, ui) =>
      prev = ui.item.prev()
      next = ui.item.next()

      if prev.length > 0 and next.length > 0
        prevPosition = parseFloat prev.attr('data-position')
        nextPosition = parseFloat next.attr('data-position')

        newPosition  = (prevPosition + nextPosition) / 2
        updateModelPosition(ui.item, newPosition)

      else if prev.length > 0
        prevPosition = parseFloat prev.attr('data-position')
        prevPrevPosition = if prev.prev().length > 0 then parseFloat(prev.prev().attr('data-position')) else 100000

        newPosition = prevPosition
        updateModelPosition(ui.item, newPosition)

        newPosition = (prevPosition + prevPrevPosition) / 2
        updateModelPosition(prev, newPosition)

      else if next.length > 0
        nextPosition = parseFloat next.attr('data-position')
        nextNextPosition = if next.next().length > 0 then parseFloat(next.next().attr('data-position')) else 100000

        newPosition = nextPosition
        updateModelPosition(ui.item, newPosition)

        newPosition = (nextPosition + nextNextPosition) / 2
        updateModelPosition(next, newPosition)


  el.sortable(options).disableSelection()