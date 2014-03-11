# ---------------------------------------------------------
# SETTINGS CATEGORIES
# ---------------------------------------------------------

@Character.Settings.CategoriesLayout = Character.Settings.DetailsLayout.extend
  newItem: ->
    $item = @ui.template.clone()

    $item.removeAttr('id')
    $item.html $item.html().replace(/objects\[\]\[\]/g, "objects[][#{ new Date().getTime() }]")

    @ui.list.append($item)

    $item.find('input').val @ui.titleInput.val()
    $item.find('.icon-plus-alt').hide()
    $item.find('.action_delete').show()
    $item.find('.action_sort').show()

  _bindEnter: ->
    @ui.titleInput.on 'keydown', (e) =>
      if e.which == 13
        @newItem()
        @ui.titleInput.val('')

        false

  _bindReorder: ->
    options =
      delay:  150
      items:  '> .category'
      handle: '.action_sort'
      update: (e, ui) =>
        # TODO: seems like this could be done much simpler with regex
        positionFields = _.select @ui.list.find("input[type=hidden]"), (f) ->
          _( $(f).attr('name') ).endsWith('[_position]')
        _.each positionFields, (el, index, list) ->
          $(el).val(positionFields.length - index)

    @ui.list.sortable(options).disableSelection()

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
    @ui.list       = @ui.content.find('.sortable-list')
    @_bindEnter()
    @_bindReorder()
    @_bindDelete()

  afterOnClose: ->
    @ui.titleInput.off 'keydown'
    @ui.list.sortable('destroy')

  beforeSave: ->
    @ui.template.remove()

chr.settingsPostCategories = (titleMenu = 'Categories') ->
  chr.settingsModule 'Post Categories',
    titleMenu: titleMenu
    detailsViewClass: Character.Settings.CategoriesLayout