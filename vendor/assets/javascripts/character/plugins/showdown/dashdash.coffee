#
#  Dash Dash (WIP)
#  -- => long dash
#

window.Showdown.extensions.dashdash = (converter) ->
  [
    {
      type: 'lang',
      filter: (text) ->
        text.replace(' -- ', ' &mdash; ')
    }
  ]
