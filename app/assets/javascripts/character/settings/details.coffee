#
# Marionette.js ItemView Documentation
# https://github.com/marionettejs/backbone.marionette/blob/master/docs/marionette.itemview.md
#
@Character.Settings.DetailsView = Backbone.Marionette.ItemView.extend
  template: -> """<header class='chr-details-header'>
                    <span id=title class=title></span>
                    <button id=save class=save style='display: none;'>Save</button>
                  </header>
                  <section id=details_content class=chr-details-content></section>"""


  ui:
    title:           '#title'
    content:         '#details_content'
    actionSave:      '#save'

  events:
    'click #save':          'onSave'
    'click .action_delete': 'deleteItem'

  onRender: ->
    @ui.title.html(@options.titleDetails)
    @ui.content.addClass(@options.moduleName)
    $.ajax
      type: 'get'
      url:  "#{ chr.options.url }/settings/#{ @options.moduleName }"
      success: (data) => @renderContent(data)
      error: (xhr) => chr.execute('showError', xhr)


  renderContent: (html) ->
    if @ui
      @beforeRenderContent?()

      @ui.content.html(html)

      @ui.form            = @ui.content.find('form')
      @ui.newItemTemplate = @ui.content.find('#template')

      # enable save action if form found
      if @ui.form.length
        @ui.actionSave.show()
        window.shortcuts.register_combo
          keys: 'meta s'
          is_exclusive: true
          on_keyup: (event) => @onSave()

      $(document).trigger("chr-details-content.rendered", [ @ui.content ])
      $(document).trigger("chr-#{ @options.moduleName }-details-content.rendered", [ @ui.content ])

      @afterRenderContent?()

  onSave: (e) ->
    if not @ui.actionSave.hasClass('disabled')
      @beforeOnSave?()

      # this does not allow to submit template fields (Safari fix)
      @ui.newItemTemplate.remove()

      @ui.form.ajaxSubmit
        beforeSubmit: (arr, $form, options) =>
          @beforeFormSubmit?(arr, $form, options)
          @updateState('Saving')
          return true
        success: (responseText, statusText, xhr, $form) =>
          @updateState()
          @renderContent(responseText)
          @afterFormSubmitSuccess?(responseText, statusText, xhr, $form)
        error: (xhr) =>
          chr.execute('showError', xhr)
          @updateState()

    return false


  deleteItem: (e) ->
    itemCls = $(e.currentTarget).attr('data-item-class')
    item    = $(e.currentTarget).closest(".#{ itemCls }")

    # TODO: query could be optimized with one regex
    destroy_field = _.find item.find("input[type=hidden]"), (f) ->
      name = $(f).attr('name') ; _(name).endsWith('[_destroy]')

    if destroy_field
      $(destroy_field).attr('value', 'true')
      item.replaceWith(destroy_field)
    else
      item.remove()

    return false

  updateState: (state) ->
    if @ui
      if state == 'Saving'
        @ui.actionSave.addClass('disabled')
        @ui.actionSave.html 'Saving...'
      else
        setTimeout ( =>
          @ui.actionSave.removeClass('disabled')
          @ui.actionSave.html 'Save'
        ), 500

  onClose: ->
    if @ui
      @beforeOnClose?()

      window.shortcuts.unregister_combo 'meta s'

      $(document).trigger("chr-details-content.closed", [ @ui.content ])
      $(document).trigger("chr-#{ @options.moduleName }-details-content.closed", [ @ui.content ])

      @afterOnClose?()