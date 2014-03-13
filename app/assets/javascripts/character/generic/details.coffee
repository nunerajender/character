
#
# Marionette.js Item View Documentation
# https://github.com/marionettejs/backbone.marionette/blob/master/docs/marionette.itemview.md
#
@Character.Generic.DetailsHeaderView = Backbone.Marionette.ItemView.extend
  template: -> "<button id=save class='save invert' title='Save changes'>Save</button>
                <button id=cancel class=cancel title='Cancel changes'>Cancel</button>
                <div id=details_title class=title></div>
                <a id=delete class=delete href='#' title='Delete this item'>
                  <i class='fa fa-trash-o'></i>
                </a>
                <span id=details_meta class=meta></span>"

  ui:
    title:        '#details_title'
    meta:         '#details_meta'
    actionSave:   '#save'
    actionDelete: '#delete'

  initialize: ->
    if @model
      @listenTo(@model, 'change', @render, @)

  onRender: ->
    if @model
      title = @model.getTitle()
      updatedFromNow = moment(@model.get('updated_at')).fromNow()
      @ui.meta.html("updated #{ updatedFromNow }")
    else
      title = @options.title

    @ui.title.html(title)

    if not @options.deletable
      @ui.actionDelete.hide()

  updateState: (state) ->
    if @ui
      if state == 'saving'
        @ui.actionSave.addClass('disabled')
        @ui.actionSave.html 'Saving...'
      else
        setTimeout ( =>
          # need these checks when create new object, view is recreated
          @ui.actionSave.removeClass?('disabled')
          @ui.actionSave.html?('Save')
        ), 500


#
# Marionette.js Layout Documentation
# https://github.com/marionettejs/backbone.marionette/blob/master/docs/marionette.layout.md
#
@Character.Generic.DetailsLayout = Backbone.Marionette.Layout.extend
  className: 'chr-details'
  template: -> "<header id=details_header class='chr-details-header'></header>
                <section id=details_content class='chr-details-content'></section>"

  regions:
    header: '#details_header'

  ui:
    content: '#details_content'

  events:
    'click #cancel': '_cancel'
    'click #save':   '_save'
    'click #delete': '_delete'

  initialize: ->
    @module            = @options.module
    @DetailsHeaderView = @module.DetailsHeaderView

  _save: ->
    if @ui.form.length
      @beforeSave?()

      Character.Generic.Helpers.serializeDataInputs(@ui.content, @ui.form)

      if @collection
        # include fields to properly update item in a list and sort
        params = _.clone(@collection.options.constantParams)
        if @collection.sortField
          params.f = _([ params.f, @collection.sortField ]).uniq().join(',')

      @ui.form.ajaxSubmit
        data: params
        beforeSubmit: (arr, $form, options) =>
          @beforeFormSubmit?(arr, $form, options)
          @headerView.updateState('saving')
          return true
        error: (xhr) =>
          chr.execute('showError', xhr)
          @headerView.updateState()
        success: (responseText, statusText, xhr, $form) =>
          @headerView.updateState()
          @_updateModel(responseText)
          @afterFormSubmitSuccess?(responseText, statusText, xhr, $form)

    return false

  _updateModel: (resp) ->
    # string means form errors returned
    if typeof(resp) == 'string'
      return @_renderContent(resp)

    # assuming response is json
    if @model
      @model.set(resp)
      @collection.sort()
    else
      @collection.fetchPage 1, ->
        Backbone.history.navigate("#/#{chr.currentPath}/edit/#{resp._id}", { trigger: true })

  _delete: ->
    if confirm("""Delete "#{ @model.getTitle() }"?""")
      @close()
      @model.destroy
        success: ->
          Backbone.history.navigate("#/#{chr.currentPath}", { trigger: true })
        error: (model, response, options) ->
          chr.execute('error', response)
    return false

  _cancel: ->
    Backbone.history.navigate("#/#{chr.currentPath}", { trigger: true })

  _toggleFullscreen: ->
    @$el.parent().toggleClass('fullscreen')

  _renderContent: (html) ->
    if @ui
      @beforeRenderContent?()

      @ui.content.html(html)
      @ui.form = @ui.content.find('form.simple_form')

      beforeFormHelpersStart?()

      if @ui.form.length
        # form related helpers
        Character.Generic.Helpers.startDateSelect(@ui.form)
        Character.Generic.Helpers.startEditor(@ui.content, @options.editorOptions)

      $(document).trigger("chr-details-content.rendered", [ @ui.content ])
      $(document).trigger("chr-#{ @module.moduleName }-details-content.rendered", [ @ui.content ])

      @afterRenderContent?()

  onRender: ->
    window.shortcuts.register_combo { keys: 'meta s', is_exclusive: true, on_keyup: (event) => @_save() }

    if @options.fullscreen
      window.shortcuts.register_combo { keys: 'meta e', is_exclusive: true, on_keyup: (event) => @_toggleFullscreen() }

    @headerView = new @DetailsHeaderView
      model:     @model
      title:     "New #{ @options.objectName }"
      deletable: @options.deletable

    @header.show(@headerView)

    if @model then @$el.addClass('update')

    @beforeContentRequest?()

    $.ajax
      type: 'get'
      url:  @options.formUrl
      success: (data) =>
        @_renderContent(data)
      error: (xhr, ajaxOptions, thrownError) =>
        chr.execute('showError', xhr)

  onClose: ->
    window.closeDetailsView = null
    if @ui
      @beforeOnClose?()

      # unbind save
      window.shortcuts.unregister_combo 'meta s'

      # unbind fullscreen
      @$el.parent().removeClass('fullscreen')
      window.shortcuts.unregister_combo 'meta e'

      if @ui.form
        # form related helpers
        Character.Generic.Helpers.stopDateSelect(@ui.form)
        Character.Generic.Helpers.stopEditor(@ui.content)

      $(document).trigger("chr-details-content.closed", [ @ui.content ])
      $(document).trigger("chr-#{ @module.moduleName }-details-content.closed", [ @ui.content ])

      @afterOnClose?()