

#    ########     ###     ######   #### ##    ##    ###    ######## ######## 
#    ##     ##   ## ##   ##    ##   ##  ###   ##   ## ##      ##    ##       
#    ##     ##  ##   ##  ##         ##  ####  ##  ##   ##     ##    ##       
#    ########  ##     ## ##   ####  ##  ## ## ## ##     ##    ##    ######   
#    ##        ######### ##    ##   ##  ##  #### #########    ##    ##       
#    ##        ##     ## ##    ##   ##  ##   ### ##     ##    ##    ##       
#    ##        ##     ##  ######   #### ##    ## ##     ##    ##    ######## 


class IndexPaginateView extends Backbone.View
  tagName:    'div'
  className:  'chr-paginate'
  id:         'index_paginate'


  build_page_path: (num) ->
    query = @options.collection().request_params.search_query
    url = "#/#{ @options.scope }"
    url += "/search/#{ query}" if query != ''
    url += "/p#{num}"
    return url


  render_prev: (current, pages) ->
    if current == 1
      path = @build_page_path(1)
      """<li class='arrow unavailable'><a href='#{ path }'><i class='icon-chevron-left'></i></a></li>"""
    else
      path = @build_page_path(current - 1)
      """<li class='arrow'><a href='#{ path }'><i class='icon-chevron-left'></i></a></li>"""


  render_next: (current, pages) ->
    if current == pages
      path = @build_page_path(pages)
      """<li class='arrow unavailable'><a href='#{ path }'><i class='icon-chevron-right'></i></a></li>"""
    else
      path = @build_page_path(current + 1)
      """<li class='arrow'><a href='#{ path }'><i class='icon-chevron-right'></i></a></li>"""


  render_page_link: (i, current) ->
    current_cls = if i == current then 'current' else ''
    page_path   = @build_page_path(i)
    """<li class='#{ current_cls }'><a href='#{ page_path }'>#{ i }</a></li>"""


  render_first: (current, pages, left) ->
    html = ''
    html += @render_page_link(1, current) if left > 1
    html += @render_page_link(2, current) if left > 2
    html += """<li class="unavailable"><a href="">…</a></li>""" if left > 3
    return html


  render_last: (current, pages, right) ->
    dif = pages - right
    html = ''
    html += """<li class="unavailable"><a href="">…</a></li>""" if dif > 2
    html += @render_page_link((pages-1), current) if dif > 1
    html += @render_page_link(pages, current)     if dif > 0
    return html


  render_links: (current, pages) ->
    range = 3
    page_links = ''

    if pages < 10
      _.each _.range(1, pages + 1), (i) =>
        page_links += @render_page_link(i, current)
    else
      left  = current - range
      right = current + range

      if left < 1
        right += ( left * -1 )
        left   = 1
      
      if right > pages
        left  += pages - right
        right  = pages

      # first page
      page_links  += @render_first(current, pages, left)
      
      _.each _.range(left, right + 1), (i) =>
        page_links += @render_page_link(i, current)

      # last page
      page_links += @render_last(current, pages, right)

    return page_links


  render: ->
    collection  = @options.collection()
    current     = collection.current_page()
    pages       = collection.total_pages

    if pages > 1
      prev_link   = @render_prev(current, pages)
      next_link   = @render_next(current, pages)
      page_links  = @render_links(current, pages)

      html = """<ul class='pagination'>
                  #{ prev_link }
                  #{ page_links }
                  #{ next_link }
                </ul>"""
    else
      html = ''

    @$el.html html


  initialize: ->
    $('#index_view .chr-index').after @el


Character.IndexPaginateView = IndexPaginateView


