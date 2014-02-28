# ---------------------------------------------------------
# FLAT PAGES
# ---------------------------------------------------------

chr.flatPages = (opts) ->
  moduleOpts =
    menuIcon:     'edit'
    menuTitle:    'Pages'
    modelName:    'Character-FlatPage'
    listReorder:  true
    listItem:
      titleField: 'title'
      metaField:  'updated_ago'
  _(moduleOpts).extend(opts)

  chr.genericModule('Page', moduleOpts)