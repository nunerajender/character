@Character.Utils ||= {}

@Character.Utils.enableDrawers = () ->
  $('.chr-top-drawer').each (i, el) ->
    $(el).append("<a class='action-show-drawer' href='#'><i class='fa fa-angle-down'></i></a>")

  $('.chr-top-drawer .action-show-drawer').on 'click', (e) ->
    $drawer_el = $(e.currentTarget).parent()
    $drawer_el.toggleClass('shown')
    e.preventDefault()