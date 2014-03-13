# ---------------------------------------------------------
# PAGES
# ---------------------------------------------------------

@Character.Pages = {}

#
# Marionette.js Layout Documentation
# https://github.com/marionettejs/backbone.marionette/blob/master/docs/marionette.itemview.md
# character/generic/details.coffee
#
@Character.Pages.DetailsLayout = Character.Generic.DetailsLayout.extend
  _hideForm: ->
    if @ui.form.parent().hasClass 'chr-form-scrolled-up'
      editableAreaHeight = $(window).height() - 71
      @ui.page.css { 'min-height': editableAreaHeight }
      @ui.content.scrollTop @ui.form.parent().outerHeight(true)

  afterRenderContent: ->
    @ui.page = @ui.content.find('.pages-show')
    @_hideForm()

chr.pagesModule = (opts) ->
  moduleOpts =
    implementation: Character.Pages
    menuIcon:       'edit'
    menuTitle:      'Pages'
    modelName:      'Character-Page'
    listReorder:    true
    listItem:
      titleField:   'title'
      metaField:    'updated_ago'
  _(moduleOpts).extend(opts)

  chr.genericModule('Page', moduleOpts)