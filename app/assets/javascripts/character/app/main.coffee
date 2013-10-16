@Character.App ||= {}
@Character.App.MainView = Backbone.Marionette.Layout.extend
  className: 'chr-app-main'

  template: -> "<div class='left-panel'>
                  <div id=list_header class='chr-app-list-header'></div>
                  <div id=list_content class='chr-app-list'></div>
                </div>
                <div id=details class='right-panel logo'></div>"

  regions:
    list_header:  '#list_header'
    list_content: '#list_content'
    details:      '#details'

  initialize: ->
    @ListHeaderView = @options.app.ListHeaderView
    @ListView = @options.app.ListView

  onRender: ->
    @header = new @ListHeaderView(@options)
    @list   = new @ListView({ collection: @options.app.collection, app: @options.app })

    @list_header.show(@header)
    @list_content.show(@list)