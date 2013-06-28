#= require jquery
#= require jquery_ujs
#= require jquery.ui.sortable
#= require jquery.ui.datepicker
#= require jquery.form
#= require underscore
#= require underscore.string
#= require underscore.inflection
#= require backbone
#= require backbone.marionette
#= require foundation
#= require_tree ./templates
#= require_tree ./views
#= require ./_model
#= require ./_controller
#= require ./_application
#= require_self


_.mixin(_.str.exports())


class @Character extends Backbone.Marionette.Application
  render: ->
    @layout = new CharacterLayout().render()
    $('body').html(@layout.el)
    @ui = @layout.ui


  initialize_plugins: ->
    $(document).foundation('topbar section forms')


  update_user_image: ->
    @ui.user_image.attr('src', window.user_image_url)


  add_menu_item: (title, scope) ->
    html = """<li><a href="#/#{ scope }">#{ title }</a></li><li class="divider"></li>"""
    @ui.top_menu.append(html)


  add_menu_items: ->
    _.each @submodules, (m) => @add_menu_item(m.options.pluralized_name, m.options.scope)
    @layout.select_menu_item(@layout.scope)


  jump_to_first_app: ->
    if window.location.hash == "" 
      path = $('#menu .top-bar-section .left li a:eq(0)').attr 'href'
      window.location.hash = path


  add_module: (options) ->
    new CharacterApp(options)



@character = new Character()


@character.on "initialize:before", (options) ->
  @render()


@character.on "initialize:after", (options) ->
  # backbone history
  if Backbone.history then Backbone.history.start()
  
  @initialize_plugins()
  @update_user_image()
  @add_menu_items()
  @jump_to_first_app()

  console.log('Character: Let\'s rock!')



