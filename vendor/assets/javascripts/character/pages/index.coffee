#= require_self
#= require_tree ./models
#= require_tree ./views


class Character.Pages extends Character.Generic.App
  constructor: (@options) ->
    @options.scope = 'pages'
    _.extend @options.render_item_options,
      line1_left:  'menu_or_title'
      line1_right: 'state'
    
    super @options
    @collection.model = Character.Pages.Page

    index_route = "#{ @options.scope }(/search/:query)(/p:page)"
    @router.route "#{ index_route }/new", "#{ @options.scope }_new", (query, page) =>
      @action_new()


  action_new: ->
    @edit_view = new Character.Pages.Views.Edit(@options)
    workspace.set_current_view(@edit_view)


  action_edit: (id) ->
    post = @collection.get(id)

    config_with_model = { model: post }
    _.extend(config_with_model, @options)

    @edit_view = new Character.Pages.Views.Edit(config_with_model)
    workspace.set_current_view(@edit_view)


Character.Pages.Views  = {}


