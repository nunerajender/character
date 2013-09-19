#= require ./character_menu

class @CharacterApplicationLayout extends Backbone.Marionette.Layout
  id:        'character'
  className: 'character'

  template: -> """<div id='content' class='chr-content'></div>"""

  onRender: ->
    @menu = new CharacterApplicationMenu().render()
    @$el.prepend(@menu.el)

    $('body').prepend(@el)

  regions:
    content: '#content'