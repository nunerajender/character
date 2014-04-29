# ---------------------------------------------------------
# SETTINGS CATEGORIES
# ---------------------------------------------------------

@Character.Settings.CategoriesLayout = Character.Settings.DetailsLayout.extend
  newItem: ->
    $item = @ui.template.clone()

    $item.removeAttr('id')

    objectId = new Date().getTime()
    $item.find('[name]').each (idx, el) ->
      newName = $(el).attr('name').replace(/objects\[\]\[\]/g, "objects[][#{ objectId }]")
      $(el).attr('name', newName)

    @ui.reorderableItems.prepend($item)

    $item.find('.icon-plus-alt').hide()
    $item.find('.action_delete').show()
    $item.find('.action_sort').show()

  _bindEnter: ->
    @ui.titleInput.on 'keydown', (e) =>
      if e.which == 13
        @newItem()
        @ui.titleInput.val('')

        false

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
    @ui.titleInput = @ui.template.find('.objects_title input')
    @_bindEnter()
    @_bindDelete()

  afterOnClose: ->
    @ui.titleInput.off 'keydown'

  beforeSave: ->
    @ui.template.remove()

chr.settingsPostCategories = (titleMenu = 'Categories') ->
  chr.settingsModule 'Post Categories',
    titleMenu: titleMenu
    detailsViewClass: Character.Settings.CategoriesLayout