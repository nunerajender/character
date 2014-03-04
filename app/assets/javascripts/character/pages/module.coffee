# ---------------------------------------------------------
# PAGES
# ---------------------------------------------------------

@Character.Pages = {}

#
# Marionette.js Layout Documentation
# https://github.com/marionettejs/backbone.marionette/blob/master/docs/marionette.itemview.md
# character/generic/details.coffee
@Character.Pages.DetailsLayout = Character.Generic.DetailsLayout.extend

chr.pagesModule = (opts) ->
  moduleOpts =
    menuIcon:     'edit'
    menuTitle:    'Pages'
    modelName:    'Character-Page'
    listReorder:  true
    listItem:
      titleField: 'title'
      metaField:  'updated_ago'
  _(moduleOpts).extend(opts)

  chr.genericModule('Page', moduleOpts)