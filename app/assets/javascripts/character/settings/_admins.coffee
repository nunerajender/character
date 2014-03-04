# ---------------------------------------------------------
# SETTINGS ADMINS
# ---------------------------------------------------------

@Character.Settings.AdminsView = Character.Settings.DetailsView.extend
  newItem: ->
    $item = @ui.template.clone()

    $item.removeAttr('id')
    $item.html $item.html().replace(/objects\[\]\[\]/g, "objects[][#{ new Date().getTime() }]")

    @ui.template.before($item)

    $item.find('input').val @ui.emailInput.val()
    $item.find('.icon-plus-alt').hide()
    $item.find('.action_delete').show()
    $item.find('.action_sort').show()

  _bindEnter: ->
    @ui.emailInput.on 'keydown', (e) =>
      if e.which == 13
        @newItem()
        @ui.emailInput.val ''
        e.preventDefault()

  afterRenderContent: ->
    @ui.template   = $('#template')
    @ui.emailInput = @ui.template.find('.objects_email input')
    @_bindEnter()

  afterOnClose: ->
    @ui.emailInput.off 'keydown'


chr.settingsAdmins = ->
  chr.settingsModule 'Admins',
    detailsViewClass: Character.Settings.AdminsView