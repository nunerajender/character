#= require ./list

class @GenericAppLayout extends Backbone.Marionette.Layout
  className: 'chr-generic-app-layout'

  template: -> """<div class='left-panel' id='left_panel'></div><aside class='right-panel logo' id='logo'></aside>"""

  regions:
    left_panel: '#left_panel'