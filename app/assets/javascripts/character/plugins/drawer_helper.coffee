@Character.Utils ||= {}

@Character.Utils.startDrawerHelper = ($form) ->
  $form.find('.chr-helper-drawer').each (i, el) ->
    $(el).append("<a class='action-show-drawer' href='#'><i class='fa fa-angle-down'></i></a>")

  $form.find('.chr-helper-drawer .action-show-drawer').on 'click', (e) ->
    $drawer_el = $(e.currentTarget).parent()
    $drawer_el.toggleClass('shown')
    e.preventDefault()

@Character.Utils.stopDrawerHelper = ($form) ->
  $form.find('.chr-helper-drawer .action-show-drawer').off 'click'