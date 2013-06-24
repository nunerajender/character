

#    ######## ######## ##     ## ########  ##          ###    ######## ########  ######  
#       ##    ##       ###   ### ##     ## ##         ## ##      ##    ##       ##    ## 
#       ##    ##       #### #### ##     ## ##        ##   ##     ##    ##       ##       
#       ##    ######   ## ### ## ########  ##       ##     ##    ##    ######    ######  
#       ##    ##       ##     ## ##        ##       #########    ##    ##             ## 
#       ##    ##       ##     ## ##        ##       ##     ##    ##    ##       ##    ## 
#       ##    ######## ##     ## ##        ######## ##     ##    ##    ########  ######  


Templates = 
  Panel: (params) ->
    # --------------------------
    # params =
    #   classes
    #   title
    #   actions  
    #   content
    # --------------------------
    """ <div class='chr-panel #{ params.classes }'>
          <section>
            <header>
              <strong>#{ params.title }</strong>
              <aside>
                #{ params.actions }
              </aside>
            </header>
            #{ params.content }
          </section>
        </div>"""


  Index: (params) ->
    # --------------------------
    # params =
    #   title
    #   new_item_link
    # --------------------------
    actions = ''
    
    if params.searchable
      query = params.search_query ? ''
      actions += "<span class='chr-search-widget'>
                    <i class='general foundicon-search'></i>
                    <input id='search_input' type='text' placeholder='Search...' value='#{ query }' />
                  </span>"
    
    #if params.search_query
    #  #actions += "<a href='#{ params.index_url }' title='Back to index' class='general foundicon-remove'></a>"
    #else
    
    if params.new_item_url # show new button when not in search view
      actions += "<a href='#{ params.new_item_url }' title='Create new' class='general foundicon-add-doc'></a>"

    Character.Templates.Panel
      classes: 'left'
      title:   params.title
      actions: actions
      content: """<ul class='chr-index'></ul>"""


  IndexItem: (context) ->
    params =
      action_path:  ''
      image_url:    ''
      line1_left:   ''
      line1_right:  ''
      line2_left:   ''
      line2_right:  ''

    _.extend(params, context)

    image = if params.image_url then "<img src='#{ params.image_url }' width=56px height=56px />" else ''

    """ <a href='#{ params.action_path }'>
          #{ image }
          <div>
            <strong class='chr-line-left'>#{ params.line1_left }</strong>
            <aside><small class='chr-line-right'>#{ params.line1_right }</small></aside>
          </div>
          <div class='chr-line-2'>
            <small><em class='chr-line-left'>#{ params.line2_left }</em></small>
            <aside class='chr-line-right'><small>#{ params.line2_right }</small></aside>
          </div>
        </a>"""  


  Settings: (params) ->
    # --------------------------
    # params =
    #   content
    # --------------------------
    """ <div class='chr-settings chr-form' id=settings_dlg style='display:none;'>
          #{ params.content }
        </div>
        <a href=# id=settings_btn class=chr-btn><i class='general foundicon-settings' /></a>"""



Character.Templates = Templates

