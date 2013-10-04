@Character.Plugins ||= {}

@Character.Plugins.enableDrawers = () ->
  $('.chr-top-drawer').append("<a class='action-show-drawer' href='#'><i class='icon-angle-down'></i></a>")
  $('.chr-top-drawer .action-show-drawer').on 'click', (e) ->
    $(e.currentTarget).parent().toggleClass('shown')
    e.preventDefault()