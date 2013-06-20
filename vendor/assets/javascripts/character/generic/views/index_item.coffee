



#    #### ######## ######## ##     ## 
#     ##     ##    ##       ###   ### 
#     ##     ##    ##       #### #### 
#     ##     ##    ######   ## ### ## 
#     ##     ##    ##       ##     ## 
#     ##     ##    ##       ##     ## 
#    ####    ##    ######## ##     ## 




class IndexItemView extends Backbone.View
  tagName: 'li'


  render: =>
    action_name = @options.render_item_options.action_name ? 'edit'
    config =
      action_path: "#{ @options.current_index_path }/#{ action_name }/#{ @model.id }"
    
    _.each @options.render_item_options, (val, key) =>
      unless key == 'action_name'
        config[key] = @model.get(val) ? ( if @model[val] then @model[val]() )
    
    html = Character.Templates.IndexItem(config)

    @$el.html html
    @$el.attr('data-id', @model.id)
    return this


  initialize: ->
    @listenTo(@model, 'change',  @render)
    @listenTo(@model, 'destroy', @remove)
    @render()


Character.IndexItemView = IndexItemView



