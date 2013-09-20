#= require ./character_layout

@character = new Backbone.Marionette.Application()


@character.on "initialize:before", (options) ->

  # render application layout
  @layout = new CharacterLayout()
  $('body').prepend(@layout.render().el)

  # set user avatar
  @layout.menu.ui.avatar.attr('src', options.user.avatar_url)

  # add project logo
  $("<style>#logo{background-image:url('#{ options.logo }');}</style>").appendTo("head")

  # initialize foundation plugins
  $(document).foundation('topbar section forms dropdown')


@character.on "initialize:after", (options) ->

  # jump to the first app in list on first load
  location.hash = @layout.menu.ui.items.find('a').attr('href') if location.hash == ""

  Backbone.history.start() if Backbone.history