#= require ./character_layout

@character = new Backbone.Marionette.Application()

@character.on "initialize:before", (options) ->
  @layout = new CharacterApplicationLayout().render()

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

  # initialize foundation plugins
  $(document).foundation('topbar section forms dropdown')

  # jump to the first app in list on first load
  location.hash = @layout.menu.ui.items.find('a').attr('href') if location.hash == ""

  # add project logo
  $("<style>#logo{background-image:url('#{@options.logo}');}</style>").appendTo("head")

  Backbone.history.start() if Backbone.history