class Character.Pages.Views.Settings extends Character.SettingsView
  render_settings: ->
    menu        = @model?.get('menu')         ? ''
    permalink   = @model?.get('permalink')    ? ''
    description = @model?.get('description')  ? ''
    keywords    = @model?.get('keywords')     ? ''

    featured_image_form_tag = @render_featured_image_form()
    
    """ #{ featured_image_form_tag }
        <input type=text id=menu value='#{ menu }' placeholder='Menu name' />
        <input type=text id=permalink_override value='#{ permalink }' placeholder='Permalink' />
        <textarea id=description rows=5 placeholder='Description'>#{ description }</textarea>
        <input type=text id=keywords value='#{ keywords }' placeholder='Keywords splitted with comma' />"""


  description: ->
    $('#description').val()


  permalink: ->
    $('#permalink_override').val()


  keywords: ->
    $('#keywords').val()


  menu: ->
    $('#menu').val()





