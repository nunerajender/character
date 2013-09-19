#= require ./character_layout

class @CharacterApplication extends Backbone.Marionette.Application
  render: ->
    @layout = new CharacterApplicationLayout().render()
    $('body').prepend(@layout.el)

  after: ->
    Backbone.history.start() if Backbone.history

    # @initialize_plugins()
    # @update_user_image()
    # @add_menu_items()
    # @jump_to_first_app()

    # console.log('May all beings be happy!')