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
    newItemTemplate: '#new_item_template'
    content:         '#details_content'
    actionSave:      '#save'
    # actions:            '#actions'


  onRender: ->
    @ui.title.html(@options.titleDetails)
    @ui.content.addClass(@options.moduleName)
    $.ajax
      type: 'get'
      url:  "#{ chr.options.url }/settings/#{ @options.moduleName }"
      success: (data) => @renderForm(data)
      error: (xhr) => chr.execute('showError', xhr)


  renderForm: (html) ->
    if @ui
      @ui.content.html(html)

      @ui.form              = @ui.content.find('form')
      @ui.newItemTemplate = @ui.content.find('#new_item_template')

      # if @ui.newItemTemplate.length and not @ui.actions.find('.action_new').length
      #   @ui.actions.append("<i class='chr-action-pin'></i><a class='action_new'>New</a>")

      if @ui.form.length
        @ui.actionSave.show()

      @afterFormRendered?()


  events:
    'click .chr-action-save': 'onSave'
    'click .action_new':      'addItem'
    'click .action_cancel':   'cancelItem'
    'click .action_delete':   'deleteItem'


  onSave: (e) ->
    if not $(e.currentTarget).hasClass('disabled')

      # this does not allow to submit template fields (Safari fix)
      @ui.newItemTemplate.remove()

      @ui.form.ajaxSubmit
        beforeSubmit: (arr, $form, options) =>
          @updateState('Saving')
          return true
        error: (xhr) =>
          chr.execute('showError', xhr)
          @updateState()
        success: (responseText, statusText, xhr, $form) =>
          if @onSaved
            @onSaved responseText, =>
              @updateState()
              @renderForm(responseText)
          else
            @updateState()
            @renderForm(responseText)

    return false


  addItem: ->
    html = @ui.newItemTemplate.html()
    html = html.replace(/objects\[\]\[\]/g, "objects[][#{ new Date().getTime() }]")
    @ui.newItemTemplate.before(html)

    @afterAddItem?()


  cancelItem: (e) ->
    itemCls = $(e.currentTarget).attr('data-item-class')
    $(e.currentTarget).closest(".#{ itemCls }").remove() ; return false


  deleteItem: (e) ->
    if confirm("Are you sure about deleting this?")
      itemCls = $(e.currentTarget).attr('data-item-class')
      item    = $(e.currentTarget).closest(".#{ itemCls }")

      destroy_field = _.find item.find("input[type=hidden]"), (f) ->
        name = $(f).attr('name')
        _(name).endsWith('[_destroy]')

      $(destroy_field).attr('value', 'true')
      item.replaceWith(destroy_field)
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