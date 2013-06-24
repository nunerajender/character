

#    #### ##    ## ########  ######## ##     ## 
#     ##  ###   ## ##     ## ##        ##   ##  
#     ##  ####  ## ##     ## ##         ## ##   
#     ##  ## ## ## ##     ## ######      ###    
#     ##  ##  #### ##     ## ##         ## ##   
#     ##  ##   ### ##     ## ##        ##   ##  
#    #### ##    ## ########  ######## ##     ## 


class IndexView extends Backbone.View
  tagName:    'div'
  id:         'index_view'


  #
  # Resizing min-height of the panels
  #

  resize_panel: ->
    top_nav_height      = 40
    margin_top_bottom   = 14 * 2
    panel_header_height = 34
    paginate_height     = 24 #if @options.paginate then 24 else 0
    window_height       = $(window).innerHeight()

    index_min_height = window_height - (top_nav_height + margin_top_bottom + panel_header_height + paginate_height) 
    panel_min_height = window_height - (top_nav_height + margin_top_bottom + panel_header_height) + paginate_height + 10

    $('.chr-index').css               'min-height', index_min_height
    $('.chr-panel.left section').css  'min-height', panel_min_height

    item_height = 71

    collection = @options.collection()
    collection.request_params.per_page = Math.floor((index_min_height - paginate_height) / item_height)
    
    
    $(window).off 'resize.character'
    $(window).on 'resize.character', =>
      @resize_panel()


  #
  # Sorting items with Drag'n'Drop
  #

  enable_sorting: ->
    sort_options =
      stop: (e, ui) =>
        ids = this.$('li').map(-> $(this).attr('data-id')).get()        
        $.post "/admin/api/#{ @options.model_slug }/reorder", { _method: 'post', ids: ids }

    $(@items_el).sortable(sort_options).disableSelection()


  #
  # Navigation experience
  #

  set_active: (id) ->
    @unset_active()
    $("#index_view li[data-id=#{ id }] a").addClass('active')


  unset_active: ->
    $('#index_view a.active').removeClass('active')


  events:
    'keypress #search_input': 'search'


  search: (e) ->
    if e.charCode == 13
      value = $('#search_input').val()

      path  = "#/#{ @options.scope }"
      path  = "#{ path }/search/#{ value }" if value
      
      workspace.router.navigate(path, { trigger: true })


  initialize: ->
    @render()
    @resize_panel()

    collection = @options.collection()

    collection.on('add',   @add_item,  @)
    collection.on('reset', @add_items, @)


  #
  # Rendering
  #


  render: ->
    html = Character.Templates.Index
      title:        @options.title
      searchable:   @options.searchable
      search_query: @options.collection().request_params.search_query
      index_url:    "#/#{ @options.scope }"
      new_item_url: "#/#{ @options.scope }/new"

    @$el.html html

    $('#character').append @el

    @panel_el = this.$('.chr-panel')
    @items_el = this.$('ul')


  add_item: (model) ->
    $(@items_el).find('.chr-placeholder').remove()

    item = new Character.IndexItemView
      model:                model
      current_index_path:   @options.current_index_path()
      render_item_options:  @options.render_item_options
    
    $(@items_el).append item.el


  render_placeholder: ->
    $(@items_el).append """<li class=chr-placeholder>Nothing is here yet.</li>"""


  add_items: ->
    $(@items_el).empty()

    objects = @options.collection().toArray()

    if objects.length == 0
      @render_placeholder()
    else    
      @add_item(obj) for obj in objects

      # Sorting with drag'n'drop
      @enable_sorting() if @options.reorderable

      # Add paginate
      @paginate_view = new Character.IndexPaginateView(@options) unless @paginate_view
      @paginate_view.render()


Character.IndexView = IndexView





