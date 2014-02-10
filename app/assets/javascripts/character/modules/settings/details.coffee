#
# Marionette.js ItemView Documentation
# https://github.com/marionettejs/backbone.marionette/blob/master/docs/marionette.itemview.md
#
@Character.Settings.DetailsView = Backbone.Marionette.ItemView.extend
  template: -> """<header id='header' class='chr-module-generic-details-header'>
                    <span class='title' id='title'></span><span class='chr-actions' id='actions'></span>
                    <a id='action_save' class='chr-action-save' style='display:none;'>Save</a>
                  </header>
                  <section id='form_view' class='chr-module-generic-details-form'></section>"""


  ui:
    title:              '#title'
    actions:            '#actions'
    newItemTemplate:  '#new_item_template'
    formView:          '#form_view'
    actionSave:        '#action_save'


  onRender: ->
    @ui.title.html(@options.titleDetails)
    @ui.formView.addClass(@options.moduleName)
    $.ajax
      type: 'get'
      url:  "#{ chr.options.url }/settings/#{ @options.moduleName }"
      success: (data) => @renderForm(data)
      error: (xhr) => chr.execute('showError', xhr)


  renderForm: (html) ->
    if @ui
      @ui.formView.html(html)

      @ui.form              = @ui.formView.find('form')
      @ui.newItemTemplate = @ui.formView.find('#new_item_template')

      if @ui.newItemTemplate.length and not @ui.actions.find('.action_new').length
        @ui.actions.append("<i class='chr-action-pin'></i><a class='action_new'>New</a>")

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