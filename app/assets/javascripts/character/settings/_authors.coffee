# ---------------------------------------------------------
# SETTINGS AUTHORS
# ---------------------------------------------------------

@Character.Settings.AuthorsLayout = Character.Settings.DetailsLayout.extend
  _bindAdd: ->
    @ui.actionAdd.on 'click', (e) =>
      e.preventDefault()

      $item = @ui.template.clone()

      $item.removeAttr('id')

      objectId = new Date().getTime()
      $item.find('[name]').each (idx, el) ->
        newName = $(el).attr('name').replace(/objects\[\]\[\]/g, "objects[][#{ objectId }]")
        $(el).attr('name', newName)

      @ui.template.before($item)

      $item.find('.action_add').hide()
      $item.find('.action_delete').show()

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
    @ui.actionAdd  = @ui.form.find('.action_add')

    @_bindAdd()
    @_bindDelete()

  afterOnClose: ->
    @ui.actionAdd.off 'click'

  beforeSave: ->
    @ui.template.remove()

chr.settingsPostAuthors = (titleMenu = 'Authors') ->
  chr.settingsModule 'Post Authors',
    titleMenu: titleMenu
    detailsViewClass: Character.Settings.AuthorsLayout