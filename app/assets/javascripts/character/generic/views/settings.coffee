

#     ######  ######## ######## ######## #### ##    ##  ######    ######  
#    ##    ## ##          ##       ##     ##  ###   ## ##    ##  ##    ## 
#    ##       ##          ##       ##     ##  ####  ## ##        ##       
#     ######  ######      ##       ##     ##  ## ## ## ##   ####  ######  
#          ## ##          ##       ##     ##  ##  #### ##    ##        ## 
#    ##    ## ##          ##       ##     ##  ##   ### ##    ##  ##    ## 
#     ######  ########    ##       ##    #### ##    ##  ######    ######  


class SettingsView extends Backbone.View
  tagName:    'span'
  id:         'settings'


  render_featured_image: ->
    image_id  = @model?.get('featured_image_id')  ? ''
    image_url = @model?.get('featured_image_url') ? ''

    """<img  data-image-id='#{ image_id }'
             src='#{ image_url }'
             style='width:100%;' />"""    


  render_featured_image_form: ->
    image = @render_featured_image()

    """<form  id=featured_image
              method=post
              action='/admin/api/images'
              enctype='multipart/form-data'>
          
          #{ image }
          
          <input name=_method type=hidden value=post>
          <input type=file id=image_uploader_input name=file />
          <button class='submit tiny' style='float:right;'>Upload</button>
        </form>"""


  featured_image_id: ->
    $('#featured_image img').attr 'data-image-id'


  render_settings: ->
    console.error 'render_settings method should be implemented.'


  render: ->
    featured_image_form_tag = @render_featured_image_form()
    
    html = Character.Templates.Settings
      content: @render_settings()
              
    $(this.el).html html
    return this


  initialize: ->
    html = @render().el
    $(html).attr('href', '#')
    $('#footer aside').prepend(html)

    @settings_btn = document.getElementById('settings_btn')
    @settings_dlg = document.getElementById('settings_dlg')

    @shown = false

    $('.datepicker').datepicker({ dateFormat: 'yy-mm-dd' })

    $('#featured_image').ajaxForm
      success: (obj) =>
        $('#featured_image img').attr 'src', obj.featured
        $('#featured_image img').attr 'data-image-id', obj._id
        $('#featured_image img').show()


  show_or_hide_settings_box: ->
    if @shown
      @shown = false ; $(@settings_dlg).hide()
    else
      @shown = true  ; $(@settings_dlg).show()


  events:
    'click #settings_btn':  'show_or_hide_settings_box'


Character.SettingsView = SettingsView



