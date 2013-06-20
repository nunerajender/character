class Character.Pages.Views.Redactor extends Backbone.View
  tagName:    'div'

  render: ->
    html  = @model?.get('html')  ? ''
    state = @model?.get('state') ? 'New Page'

    html = Character.Templates.Panel
      classes: 'chr-redactor'
      title:   state
      actions: ''
      content: """<div><textarea id='html'>#{ html }</textarea></div>"""

    $(this.el).html html
    return this


  initialize: ->
    html = @render().el
    $('#header').after(html)

    @html = document.getElementById('html')
    
    $(@html).redactor
      convertLinks: false
      convertDivs:  false
      buttons:      ['html', '|', 'bold', 'italic', 'deleted', '|', 'image', '|', 'link' ]
      imageGetJson: '/admin/api/images'
      imageUpload:  '/admin/api/images'
      callback: => @resize_panels()


  resize_panels: ->
    top_offset    = 156
    window_height = $(window).height()
    footer_height = $('footer').outerHeight()
    
    $('.redactor_editor').css 'height', window_height - top_offset - footer_height
    
    $(window).resize =>
      @resize_panels()


  get_html: ->
    @html.value


