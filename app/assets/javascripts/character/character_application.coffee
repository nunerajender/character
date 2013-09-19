#= require ./character_layout

@character = new Backbone.Marionette.Application()

@character.on "initialize:before", (options) ->
  @layout = new CharacterApplicationLayout().render()
  $('body').prepend(@layout.el)

@character.on "initialize:after",  (@options) ->
  # add character apps to the menu
  _.each @submodules, (m) =>
    opts = m.options
    if m.moduleName == 'Settings'
      @layout.menu.$el.find(' > a')
        .attr('href', '#/settings')
        .removeClass('browserid_logout')
        .html("<i class='icon-gears'></i> Settings")
    else
      @layout.menu.add_item(opts.path, opts.icon, opts.pluralized_name)

  # set user avatar
  @layout.menu.ui.avatar.attr('src', @options.user.avatar_url)

  # @initialize_plugins()
  # @jump_to_first_app()

  Backbone.history.start() if Backbone.history