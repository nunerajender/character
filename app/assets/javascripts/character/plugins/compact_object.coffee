_.mixin
  compactObject: (o) ->
    _.each o, (v, k) -> if !v then delete o[k] else o