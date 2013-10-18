@Character.Settings ||= {}
@Character.Settings.DetailsView = Backbone.Marionette.ItemView.extend
  template: -> """<header id='header' class='chr-settings-view-header'>
                    <span class='title' id='title'></span><span class='chr-actions' id='actions'></span>
                    <a id='action_save' class='chr-action-save' style='display:none;'>Save</a>
                  </header>
                  <section id='form_view' class='chr-settings-view-form'></section>"""

  ui:
    title:              '#title'
    actions:            '#actions'
    new_item_template:  '#new_item_template'
    form_view:          '#form_view'
    action_save:        '#action_save'

  onRender: ->
    @ui.title.html(@options.name)
    @ui.form_view.addClass(@options.path)
    $.get "#{ chr.options.url }/settings/#{ @options.path }", (html) =>
      ( @ui.form_view.html(html) ; @onFormRendered() )  if @ui.form_view

  onFormRendered: ->
    @ui.new_item_template = @ui.form_view.find('#new_item_template')
    if @ui.new_item_template.length > 0
      @ui.actions.append("<i class='chr-action-pin'></i><a class='action_new'>New</a>")

    @ui.form = @ui.form_view.find('form')
    if @ui.form.length > 0
      @ui.action_save.show()
      @ui.form.ajaxForm
        beforeSubmit: (arr, $form, options) => @ui.action_save.addClass('disabled'); return true
        success: (response) => @ui.action_save.removeClass('disabled')

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