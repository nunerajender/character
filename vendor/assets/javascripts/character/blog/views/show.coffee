class BlogShow extends Backbone.View
  tagName:    'div'


  render: ->
    id    = @model.id
    html  = @model.get('html')

    index_path = @options.current_index_path()

    html = Character.Templates.Panel 
      title:    @model.state()
      classes:  'right'
      actions:  """<a href='#' title='Delete this post' class='general foundicon-trash' id=delete_post></a>
                   <a href='#{ index_path }/edit/#{ id }' title='Edit post' class='general foundicon-edit'></a>
                   <a href='#' title='Close Preview' class='general foundicon-remove' id=close></a>"""
      content:  """<article class='chr-blog-post-preview' id=preview>#{ html }</article>"""

    $(this.el).html html
    return this


  initialize: ->
    html = @render().el
    $('#index_view').append(html)

    @listenTo(@model, 'destroy', @remove)


  delete_post: (e) ->
    e.preventDefault()
    if confirm('Do you really want to remove this post?')
      @model.destroy()
      workspace.router.navigate('#/', {trigger: true})      


  close: (e) ->
    e.preventDefault() if e
    @back_to_index()
    @remove()
    workspace.current_view.unset_active()


  back_to_index: ->
    index_path = @options.current_index_path()
    workspace.router.navigate(index_path, { trigger: true })


  events:
    'click #delete_post': 'delete_post'
    'click #close':       'close'

Character.Blog.Views.BlogShow = BlogShow