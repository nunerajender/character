#= require ./list

#
# Marionette.js Layout Documentation
# https://github.com/marionettejs/backbone.marionette/blob/master/docs/marionette.layout.md
#
@Character.Generic.Layout = Backbone.Marionette.Layout.extend
  className: 'chr-module-generic'

  template: -> "<div class='left-panel'>
                  <header id=list_header class='chr-module-generic-list-header'></header>
                  <div id=list_content class='chr-module-generic-list'></div>
                </div>
                <div id=details class='right-panel chr-logo'>
                </div>"

  regions:
    list_header:  '#list_header'
    list_content: '#list_content'
    details:      '#details'

  initialize: ->
    @ListHeaderView = @options.module.ListHeaderView
    @ListView       = @options.module.ListView
    @collection     = @options.module.collection

  onRender: ->
    @header = new @ListHeaderView(@options)
    @list   = new @ListView({ collection: @collection, module: @options.module })

    @list_header.show(@header)
    @list_content.show(@list)

  closeDetails: ->
    @list.unselectCurrentItem()
    @details.close()

  updateListScope: (listScope, callback) ->
    @header.update(listScope)
    @collection.setScope(listScope).fetchPage(1, callback)