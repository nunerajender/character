#= require ./character_menu

@CharacterLayout = Backbone.Marionette.Layout.extend
  id:        'character'
  className: 'character'

  template: -> """<div id='content' class='chr-content'></div>"""

  onRender: ->
    @menu = new CharacterMenu().render()
    @$el.prepend(@menu.el)

  regions:
    content: '#content'