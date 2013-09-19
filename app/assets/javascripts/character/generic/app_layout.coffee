#= require ./list
#= require ./list_header

class @GenericAppLayout extends Backbone.Marionette.Layout
  className: 'chr-generic-app-layout'

  template: -> """<div class='left-panel'>
                    <div id='list_header' class='chr-generic-list-header'></div>
                    <div id='list' class='chr-generic-list'></div>
                  </div>
                  <aside class='right-panel logo' id='logo'></aside>"""

  regions:
    header: '#list_header'
    list:   '#list'

  onRender: ->
    @header.show(new GenericListHeader(@options))
    @list.show(new GenericList({ collection: @options.collection }))