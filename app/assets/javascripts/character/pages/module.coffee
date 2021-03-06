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
      headerHeight       = $('#details_header').outerHeight()
      editableAreaHeight = $(window).height() - headerHeight
      scrollTo           = @ui.page.offset().top - headerHeight + 1

      @ui.page.css { 'min-height': editableAreaHeight }
      @ui.content.scrollTop scrollTo

  afterRenderContent: ->
    @ui.page = @ui.content.find('.page')
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
    redactorOptions:
      toolbarExternal: '#redactor_toolbar'
      focusCallback: -> $('#details').addClass('chr-show-redactor-toolbar')
      blurCallback:  -> $('#details').removeClass('chr-show-redactor-toolbar')
      initCallback:  -> $('.redactor_character-redactor').attr('data-input-name', 'character_page[template_content][body]')
  _(moduleOpts).extend(opts)

  chr.genericModule('Page', moduleOpts)
