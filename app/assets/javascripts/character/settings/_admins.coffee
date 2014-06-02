# ---------------------------------------------------------
# SETTINGS ADMINS
# ---------------------------------------------------------

@Character.Settings.AdminsLayout = Character.Settings.DetailsLayout.extend
  _newItem: ->
    $item = @ui.template.clone()

    $item.removeAttr('id')

    objectId = new Date().getTime()
    $item.find('[name]').each (idx, el) ->
      newName = $(el).attr('name').replace(/objects\[\]\[\]/g, "objects[][#{ objectId }]")
      $(el).attr('name', newName)

    @ui.template.before($item)

    $item.find('.icon-plus-alt').hide()
    $item.find('.action_delete').show()
    $item.find('.action_sort').show()

  _bindEnter: ->
    @ui.emailInput.on 'keydown', (e) =>
      if e.which == 13
        @_newItem()
        @ui.emailInput.val ''
        e.preventDefault()

  _bindDelete: ->
    @ui.content.on 'click', '.action_delete', (e) ->
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
      false

  afterRenderContent: ->
    @ui.template   = $('#template')
    @ui.emailInput = @ui.template.find('.objects_email input')
    @_bindEnter()
    @_bindDelete()

  afterOnClose: ->
    @ui.emailInput.off 'keydown'
    @ui.content.off 'click', '.action_delete'

  beforeSave: ->
    #@ui.template.remove()


chr.settingsAdmins = ->
  chr.settingsModule 'Admins',
    detailsViewClass: Character.Settings.AdminsLayout