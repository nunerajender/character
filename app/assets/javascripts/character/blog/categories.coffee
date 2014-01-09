

@Character.BlogCategories ||= {}
@Character.BlogCategories.DetailsView = @Character.Settings.DetailsView.extend
  initialize: ->
    @events['click .action_select'] = 'selectCategory'

  afterFormRendered: ->
    @enableReorderableCategories()

    @ui.form.find('.input.objects_title input').change (e) ->
      $(e.currentTarget).closest('.category').find('.title').html($(e.currentTarget).val())


  afterAddItem: ->
    selected_collections = @ui.form.find('.collection.selected')
    if selected_collections.length > 1
      selected_collections.first().removeClass('selected')
    @updateCategoriesPositionValues()


  selectCategory: (e) ->
    $el = $(e.currentTarget).closest('.category')
    if $el.hasClass('selected')
      $el.removeClass('selected')
    else
      @ui.form.find('.category.selected').removeClass('selected')
      $el.addClass('selected')
    return false


  enableReorderableCategories: ->
    options =
      handle: '.title'
      update: (e, ui) => @updateCategoriesPositionValues()
    @ui.form.sortable(options).disableSelection()


  updateCategoriesPositionValues: ->
    position_fields = _.select @ui.form.find("input[type=hidden]"), (f) ->
      _( $(f).attr('name') ).endsWith('[_position]')

    total_elements = position_fields.length
    _.each position_fields, (el, index, list) -> $(el).val(total_elements - index)