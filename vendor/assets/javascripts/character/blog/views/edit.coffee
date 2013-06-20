class BlogEdit extends Backbone.View
  tagName:    'div'


  render: ->
    title = if @model then @model.get('title') else 'The New Post'
    html = """<header class='chr-panel' id=header>
                <input  id=title
                        class=chr-editor-title
                        type=text
                        placeholder='Post Title'
                        value='#{title}' />
                <div class=chr-editor-permalink id=permalink></div>
              </header>

              <footer class='chr-footer' id=footer>
                <a href=# class='chr-btn' id=back>Back to index</a>
                <aside>
                  <a href=# class='chr-btn blue' id=save_draft>Save Draft</a>
                  <a href=# class='chr-btn red' id=publish>Publish</a>
                </aside>
              </footer>"""
    $(this.el).html html
    return this


  initialize: ->
    html = @render().el
    $('#character').append(html)

    @title = document.getElementById('title')

    if @options.mode == 'redactor'
      @mode = new Character.Blog.Views.Redactor model: @model
    else
      @mode = new Character.Blog.Views.Markdown model: @model

    @settings = new Character.Blog.Views.Settings model: @model
    
    @update_permalink()


  update_or_create_post: (extra_attributes, callback) ->
    title = $(@title).val()
    slug  = _.string.slugify(title)

    attributes =
      title:              title
      slug:               slug
      md:                 @mode.get_markdown()
      html:               @mode.get_html()
      date:               @settings.date()
      tags:               @settings.tags()
      excerpt:            @settings.excerpt()
      category_id:        @settings.category_id()
      featured_image_id:  @settings.featured_image_id()
      featured:           @settings.featured()

    _.extend attributes, extra_attributes

    if @model
      @model.save(attributes, { success: callback })
    else
      @collection().create(attributes, { wait: true, success: callback })


  save_draft: (e) ->
    e.preventDefault() if e
    @update_or_create_post {published: false}, =>
      @back_to_index()


  publish: (e) ->
    e.preventDefault() if e
    @update_or_create_post {published: true}, =>    
      @back_to_index()


  back_to_index: (e) ->
    e.preventDefault() if e
    index_path  = @options.current_index_path()
    index_path += "/show/#{ @model.id }" if @model
    workspace.router.navigate(index_path, { trigger: true })


  events:
    'click #save_draft': 'save_draft'
    'click #publish':    'publish'
    'click #back':       'back_to_index'


  update_permalink: ->
    set_permalink = =>
      blog_url  = @options.blog_url
      blog_url += '/' unless _.string.endsWith(blog_url, '/')

      slug      = _.string.slugify($(@title).val())
      html      = """<strong>Permalink:</strong> #{blog_url}<strong id='slug'>#{slug}</strong>"""
      $('#permalink').html html

    $(@title).keyup => set_permalink()
    set_permalink()


Character.Blog.Views.BlogEdit = BlogEdit







