class Markdown extends Backbone.View
  tagName: 'div'


  events:
    'click .image-uploader .submit':  'upload_image'


  render_markdown: (markdown) ->
    Character.Templates.Panel
      classes:  'left'
      title:    'Markdown'
      actions:  ''
      content:  """<div><textarea id=markdown>#{ markdown }</textarea></div>"""


  render_preview: (state) ->
    Character.Templates.Panel
      classes:  'right'
      title:    state
      actions:  ''
      content:  """<article class='chr-blog-post-preview scroll'><div id=html></div></article>"""
  

  render: ->
    markdown = @model?.get('md')    ? 'Post Text'
    state    = @model?.get('state') ? 'New Post'

    html = @render_markdown(markdown) + @render_preview(state)

    $(this.el).html html
    return this


  initialize: ->
    html = @render().el
    $('#header').after(html)

    @converter  = new Showdown.converter { extensions: ['dashdash', 'github', 'image_uploader', 'video'] }
    @html       = document.getElementById('html')
    
    @code_mirror = CodeMirror.fromTextArea document.getElementById('markdown'),
      mode:         'text/x-markdown'
      lineWrapping: true
      autofocus:    true

    @code_mirror.on 'change', => @convert_text()

    @convert_text()
    @resize_panels()


  get_html: ->
    @html.innerHTML


  upload_image: (e) ->
    form = $(e.currentTarget).parent()

    form_index = $('#preview .image-uploader').index(form) + 1

    form.ajaxForm
      success: (obj) =>
        image_url       = obj.common

        md_text         = "\n" + @get_markdown() + "\n" # edge cases workaround
        updated_md_text = md_text.replace_nth_occurrence("\n(image)\n", "\n![](#{image_url})\n", form_index)
        
        updated_md_text = updated_md_text.slice(1,updated_md_text.length - 1)

        @code_mirror.setValue(updated_md_text)
        @convert_text()


  convert_text: ->
    text = @get_markdown()
    @html.innerHTML = @converter.makeHtml(text)


  get_markdown: ->
    @code_mirror.getValue()


  resize_panels: ->
    article       = $(@html).parent()

    article_top_offset  = 156 #article.offset().top
    window_height       = $(window).height()
    footer_height       = $('footer').outerHeight()
    
    article.css          'height', window_height - article_top_offset - footer_height
    $('.CodeMirror').css 'height', window_height - article_top_offset - footer_height
    
    $(window).resize =>
      @resize_panels()


Character.Blog.Views.Markdown = Markdown








