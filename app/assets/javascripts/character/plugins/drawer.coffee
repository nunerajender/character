@Character.Plugins ||= {}

@Character.Plugins.enableDrawers = () ->
  $('.chr-top-drawer').each (i, el) ->
    $(el).append("<a class='action-show-drawer' href='#'><i class='icon-angle-down'></i></a>")

    margin_top = -1 * ( $(el).position().top + $(el).height() - $(el).find('action-show-drawer').height() )
    margin_top_hidden= -1 * $(el).position().top

    $(el).attr('data-margin-top', margin_top)
    $(el).attr('data-margin-top-hidden', margin_top_hidden)

    $(el).css('margin-top', margin_top)

  $('.chr-top-drawer .action-show-drawer').on 'click', (e) ->
    $drawer_el = $(e.currentTarget).parent()

    $drawer_el.toggleClass('shown')

    if $drawer_el.hasClass('shown')
      $drawer_el.css('margin-top', $drawer_el.attr('data-margin-top-hidden') + 'px')
    else
      $drawer_el.css('margin-top', $drawer_el.attr('data-margin-top') + 'px')

    e.preventDefault()