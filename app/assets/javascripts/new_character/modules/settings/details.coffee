#
# Marionette.js ItemView Documentation
# https://github.com/marionettejs/backbone.marionette/blob/master/docs/marionette.itemview.md
#
@Character.Settings.DetailsView = Backbone.Marionette.ItemView.extend
  template: -> """<header id='header' class='chr-module-settings-details-header'>
                    <span class='title' id='title'></span><span class='chr-actions' id='actions'></span>
                    <a id='action_save' class='chr-action-save' style='display:none;'>Save</a>
                  </header>
                  <section id='form_view' class='chr-module-settings-details-form'></section>"""

  ui:
    title:              '#title'
    actions:            '#actions'
    new_item_template:  '#new_item_template'
    form_view:          '#form_view'
    action_save:        '#action_save'

  onRender: ->
    @ui.title.html(@options.titleDetails)
    @ui.form_view.addClass(@options.moduleName)
    $.ajax
      type: 'get'
      url:  "#{ chr.options.url }/settings/#{ @options.moduleName }"
      success: (data) => @renderForm(data)
      error: (response) => chr.execute('showErrorModal', response)

  renderForm: (html) ->
    if @ui
      @ui.form_view.html(html)

      @ui.form              = @ui.form_view.find('form')
      @ui.new_item_template = @ui.form_view.find('#new_item_template')

      if @ui.new_item_template.length and not @ui.actions.find('.action_new').length
        @ui.actions.append("<i class='chr-action-pin'></i><a class='action_new'>New</a>")

      if @ui.form.length
        @ui.action_save.show()

        @ui.form.submit =>
          @updateState('Saving')

          # this does not allow to submit template fields (Safari fix)
          @ui.new_item_template.remove()

          $.ajax
            type: @ui.form.attr('method')
            url:  @ui.form.attr('action')
            data: @ui.form.serialize()
            success: (data) =>
              @updateState()
              @renderForm(data)
            error: (data) =>
              Character.Plugins.showErrorModal(data)
              @updateState()

          return false

      @afterFormRendered?()

  events:
    'click .chr-action-save': 'onSave'
    'click .action_new':      'addItem'
    'click .action_cancel':   'cancelItem'
    'click .action_delete':   'deleteItem'

  onSave: (e) ->
    (unless $(e.currentTarget).hasClass('disabled') then @ui.form.submit()) ; return false

  addItem: ->
    html = @ui.new_item_template.html()
    html = html.replace(/objects\[\]\[\]/g, "objects[][#{ new Date().getTime() }]")
    @ui.new_item_template.before(html)

    @afterAddItem?()

  cancelItem: (e) ->
    item_cls = $(e.currentTarget).attr('data-item-class')
    $(e.currentTarget).closest(".#{ item_cls }").remove() ; return false

  deleteItem: (e) ->
    if confirm("Are you sure about deleting this?")
      item_cls = $(e.currentTarget).attr('data-item-class')
      item     = $(e.currentTarget).closest(".#{ item_cls }")

      destroy_field = _.find item.find("input[type=hidden]"), (f) ->
        name = $(f).attr('name')
        _(name).endsWith('[_destroy]')

      $(destroy_field).attr('value', 'true')
      item.replaceWith(destroy_field)
    return false

  updateState: (state) ->
    # TODO: we should block users navigation until state has changed again
    if @ui
      if state == 'Saving'
        @ui.action_save.addClass('disabled')
        @ui.action_save.html 'Saving...'
      else
        setTimeout ( =>
          @ui.action_save.removeClass('disabled')
          @ui.action_save.html 'Save'
        ), 500