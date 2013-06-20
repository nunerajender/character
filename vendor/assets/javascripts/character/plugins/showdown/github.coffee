#
#  Github Extension (WIP)
#  ~~strike-through~~   ->  <del>strike-through</del>
#

window.Showdown.extensions.github = (converter) ->
  [
    {
      # strike-through
      # NOTE: showdown already replaced "~" with "~T", so we need to adjust accordingly.
      type    : 'lang',
      regex   : '(~T){2}([^~]+)(~T){2}',
      replace : (match, prefix, content, suffix) ->
        "<del>#{content}</del>"
    }
  ]



