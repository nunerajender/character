#= require jquery
#= require jquery_ujs
#= require jquery.ui.sortable
#= require jquery.ui.datepicker

#= require browserid
#= require foundation

#= require lodash
#= require underscore.string

#= require character/plugins/backbone
#= require character/plugins/underscore.string.slugify
#= require character/plugins/replace_nth_occurrence
#  require character/plugins/jquery.smartresize
#= require character/plugins/jquery.form
#= require character/plugins/jquery.trunk8
#= require character/plugins/redactor
#= require character/plugins/showdown
#= require character/plugins/moment

#= require codemirror
#= require codemirror/modes/javascript
#= require codemirror/modes/css
#= require codemirror/modes/xml
#= require codemirror/modes/htmlmixed
#= require codemirror/modes/markdown

#= require_self
#= require character/generic
#= require character/blog
#= require character/pages



# ##      ##  #######  ########  ##    ##  ######  ########     ###     ######  ######## 
# ##  ##  ## ##     ## ##     ## ##   ##  ##    ## ##     ##   ## ##   ##    ## ##       
# ##  ##  ## ##     ## ##     ## ##  ##   ##       ##     ##  ##   ##  ##       ##       
# ##  ##  ## ##     ## ########  #####     ######  ########  ##     ## ##       ######   
# ##  ##  ## ##     ## ##   ##   ##  ##         ## ##        ######### ##       ##       
# ##  ##  ## ##     ## ##    ##  ##   ##  ##    ## ##        ##     ## ##    ## ##       
#  ###  ###   #######  ##     ## ##    ##  ######  ##        ##     ##  ######  ######## 



class CharacterWorkspace
  # allows Character apps to communicate between each other

  constructor: ->
    @current_view = null
    @router       = new Backbone.Router()
    @collections  = {}
    @apps         = {}

  
  current_view_is: (scope, view_id) ->
    (@current_view and @current_view.id == view_id and @current_view.options.scope == scope)


  set_current_view: (view) ->
    (@current_view.remove() ; delete @current_view) if @current_view
    @current_view = view


  launch: ->
    if window.character_apps
      _.each window.character_apps, (callback, app) =>
        @apps[app] = callback()

    Backbone.history.start()


window.Character      = CharacterWorkspace


