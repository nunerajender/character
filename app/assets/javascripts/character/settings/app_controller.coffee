

@Character.Settings.Controller = Marionette.Controller.extend
  index: () ->
    console.log 'settings index'

  edit: (module) ->
    console.log 'settings edit'