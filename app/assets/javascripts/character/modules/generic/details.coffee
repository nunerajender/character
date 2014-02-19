
#
# Marionette.js Item View Documentation
# https://github.com/marionettejs/backbone.marionette/blob/master/docs/marionette.itemview.md
#
@Character.Generic.DetailsHeaderView = Backbone.Marionette.ItemView.extend
  template: -> "<span id=details_title class='title'></span><span class='chr-actions'><i class='chr-action-pin'></i><a id=action_delete>Delete</a></span>
                <div id=details_meta class='meta'></div>
                <a id='action_save' class='chr-action-save'><span class='save'>Save</span></a>"

  ui:
    title:        '#details_title'
    meta:         '#details_meta'
    actionSave:   '#action_save'
    actionDelete: '#action_delete'

  initialize: ->
    if @model
      @listenTo(@model, 'change', @render, @)

  onRender: ->
    if @model
      title = @model.getTitle()
      updatedFromNow = moment(@model.get('updated_at')).fromNow()
      @ui.meta.html("Updated #{ updatedFromNow }")
    else
      title = @options.title

    @ui.title.html(title)

    if not @options.deletable
      @ui.actionDelete.hide().prev().hide()

  updateState: (state) ->
    if @ui
      if state == 'saving'
        @ui.actionSave.addClass('disabled')
        @ui.actionSave.html 'Saving...'
      else
        setTimeout ( =>
          @ui.actionSave.removeClass('disabled')
          @ui.actionSave.html('Save')
        ), 500


#
# Marionette.js Layout Documentation
# https://github.com/marionettejs/backbone.marionette/blob/master/docs/marionette.itemview.md
#
@Character.Generic.DetailsLayout = Backbone.Marionette.Layout.extend
  className: 'chr-module-generic-details'
  template: -> "<header id=details_header class='chr-module-generic-details-header'></header>
                <div id=details_content class='chr-module-generic-details-content'></div>"

  regions:
    header: '#details_header'

  ui:
    content: '#details_content'

  initialize: ->
    @module            = @options.module
    @DetailsHeaderView = @module.DetailsHeaderView
    @router            = @module.router

  onRender: ->
    @headerView = new @DetailsHeaderView
      model:     @model
      title:     "New #{ @options.objectName }"
      deletable: @options.deletable

    @header.show(@headerView)

    if @model
      @$el.addClass('edit')

    $.ajax
      type: 'get'
      url:  @options.formUrl
      success: (data) =>
        @renderContent(data)
      error: (xhr, ajaxOptions, thrownError) =>
        chr.execute('showError', xhr)

  renderContent: (html) ->
    if @ui
      @ui.content.html(html)

      @ui.form = @ui.content.find('form.simple_form')

      if @ui.form.length
        chr.execute('startDetailsFormPlugins', @ui.form)

      $(document).trigger("chr-generic-details-content.rendered", [ @ui.content ])
      $(document).trigger("chr-#{ @module.moduleName }-details-content.rendered", [ @ui.content ])
      @afterContentRendered?()

  events:
    'click #action_save':   'onSave'
    'click #action_delete': 'onDelete'

  onSave: ->
    if @ui.form.length
      chr.execute('beforeFormSubmit', @ui)

      # include fields to properly update item in a list and sort
      params = _.clone(@collection.options.constantParams)
      if @collection.sortField
        params.f = _([ params.f, @collection.sortField ]).uniq().join(',')

      @ui.form.ajaxSubmit
        data: params
        beforeSubmit: (arr, $form, options) =>
          @headerView.updateState('saving')
          return true
        error: (xhr) =>
          chr.execute('showError', xhr)
          @headerView.updateState()
        success: (responseText, statusText, xhr, $form) =>
          @headerView.updateState()
          @updateModel(responseText)

    return false

  updateModel: (resp) ->
    # when response is a string, that means form with errors returned
    if typeof(resp) == 'string'
      return @renderContent(resp)

    # assuming response is json
    if @model
      @model.set(resp)
      @collection.sort()
    else
      @collection.fetchPage(1)

  onDelete: ->
    if confirm("""Are you sure about deleting "#{ @model.getTitle() }"?""")
      @close()
      @model.destroy
        success: =>
          @router.navigate(chr.path)
        error: (model, response, options) ->
          chr.execute('showError', response)
    return false

  onClose: ->
    if @ui
      if @ui.form
        chr.execute('stopDetailsFormPlugins', @ui.form)
      $(document).trigger("chr-generic-details-content.closed", [ @ui.content ])
      $(document).trigger("chr-#{ @module.moduleName }-details-content.closed", [ @ui.content ])