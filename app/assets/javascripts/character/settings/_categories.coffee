# ---------------------------------------------------------
# SETTINGS CATEGORIES
# ---------------------------------------------------------

@Character.Settings.CategoriesView = Character.Settings.DetailsView.extend
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

  afterRenderContent: ->
    @ui.template   = $('#template')
    @ui.titleInput = @ui.template.find('.objects_title input')
    @ui.list       = @ui.content.find('.sortable-list')
    @_bindEnter()
    @_bindReorder()

  afterOnClose: ->
    @ui.titleInput.off 'keydown'
    @ui.list.sortable('destroy')

chr.settingsPostCategories = (titleMenu = 'Categories') ->
  chr.settingsModule 'Post Categories',
    titleMenu: titleMenu
    detailsViewClass: Character.Settings.CategoriesView