

@Character.module 'Settings.Layout', (Module, App) ->

  #========================================================
  # Main
  #========================================================
  Module.Main = Backbone.Marionette.Layout.extend
    className: 'chr-settings-layout'

    template: -> """<aside class='left-panel'>
                      <div id='list_header' class='chr-settings-list-header'></div>
                      <div id='list_content' class='chr-settings-list'></div>
                    </aside>
                    <div class='right-panel logo' id='logo'></div>"""

    regions:
      list_header:  '#list_header'
      list_content: '#list_content'

    onRender: ->
      # @header = new Module.ListHeader(@options)
      # @list   = new Module.List({ collection: @options.app.collection })

      # @list_header.show(@header)
      # @list_content.show(@list)