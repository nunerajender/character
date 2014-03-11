#
# character/generic/details.coffee
#
@Character.Settings.DetailsHeaderView = Character.Generic.DetailsHeaderView.extend
  initialize: ->

  onRender: ->
    @ui.actionDelete.hide()

#
# character/generic/details.coffee
#
@Character.Settings.DetailsLayout = Character.Generic.DetailsLayout.extend
  beforeContentRequest: ->
    @ui.content.addClass(@options.moduleName)
    @headerView.ui.title.html(@options.titleDetails)