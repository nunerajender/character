#= require ./list
#= require ./list_header

@AppLayout = Backbone.Marionette.Layout.extend
  className: 'chr-app-layout'

  template: -> """<div class='left-panel'>
                    <div id='list_header' class='chr-app-list-header'></div>
                    <div id='list_content' class='chr-app-list'></div>
                  </div>
                  <aside class='right-panel logo' id='logo'></aside>"""

  regions:
    list_header:  '#list_header'
    list_content: '#list_content'

  onRender: ->
    @header = new AppListHeader(@options)
    @list   = new AppList({ collection: @options.collection })

    @list_header.show(@header)
    @list_content.show(@list)