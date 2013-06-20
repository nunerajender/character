class Settings extends Character.SettingsView
  render_settings: ->
    date      = @model?.get('date')     ? ''
    excerpt   = @model?.get('excerpt')  ? ''
    tags      = @model?.get('tags')     ? ''
    featured  = if @model?.get('featured') then 'checked' else ''

    featured_image_form_tag = @render_featured_image_form()
    category_options_tag    = '' #if blog.options.categories then @category_options() else ''
    
    """#{ featured_image_form_tag }

        <input id=date class=datepicker type=text value='#{date}' placeholder='Date'>
        <textarea id=excerpt rows=5 placeholder='Excerpt'>#{excerpt}</textarea>
        <input type=text id=tags value='#{tags}' placeholder='Keywords splitted with comma' />
        <label for=featured><input type=checkbox id=featured #{ featured } /> This post is featured</label>

        #{ category_options_tag }"""


  render_select_categories: ->
    post_category     = @model?.category()
    category_options  = '<option>No set</option>'

    @categories().each (c) ->
      if post_category and post_category.id == c.id
        category_options += """<option value='#{c.id}' selected>#{c.get('title')}</option>"""
      else
        category_options += """<option value='#{c.id}'>#{c.get('title')}</option>"""

    """<label>Pick a category for this post:</label>
       <select id=category_id class=categories>
         #{category_options}
       </select>"""


  date: ->
    $('#date').val()
 

  excerpt: ->
    $('#excerpt').val()


  tags: ->
    $('#tags').val()


  featured: ->
    $('#featured').is(':checked')


  category_id: ->
    $('#category_id').val()


Character.Blog.Views.Settings = Settings




