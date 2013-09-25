#= require jquery.ui.sortable

@Character.Plugins ||= {}

@Character.Plugins.reorderable = (el, collection) ->
  update_model_position = ($el, position) ->
    model_id = $el.attr 'data-id'
    model    = collection.get(model_id)
    model.save({ _position: position }, { process_for_save: true })


  sort_options =
    delay:       150
    placeholder: 'placeholder'

    update: (e, ui) =>
      prev = ui.item.prev()
      next = ui.item.next()

      if prev.length > 0 and next.length > 0
        prev_position = parseFloat prev.attr('data-position')
        next_position = parseFloat next.attr('data-position')

        new_position  = (prev_position + next_position) / 2
        update_model_position(ui.item, new_position)

      else if prev.length > 0
        prev_position = parseFloat prev.attr('data-position')
        prev_prev_position = if prev.prev().length > 0 then parseFloat(prev.prev().attr('data-position')) else 100000

        new_position = prev_position
        update_model_position(ui.item, new_position)

        new_position = (prev_position + prev_prev_position) / 2
        update_model_position(prev, new_position)

      else if next.length > 0
        next_position = parseFloat next.attr('data-position')
        next_next_position = if next.next().length > 0 then parseFloat(next.next().attr('data-position')) else 100000

        new_position = next_position
        update_model_position(ui.item, new_position)

        new_position = (next_position + next_next_position) / 2
        update_model_position(next, new_position)


  el.sortable(sort_options).disableSelection()