#
#  Image Uploader Extension
#  (image)  ->  <p><form ... /></p>
#

window.Showdown.extensions.imageuploader = (converter) ->
  [
    {
      type:   'lang',
      filter: (text) ->
        url         = '/admin/api/images'
        widget_html = """<p>
                           <form  class=image-uploader
                                  method=post
                                  action='#{ url }'
                                  enctype='multipart/form-data'>
                             
                             <input name=_method
                                    type=hidden
                                    value=post />
                             
                             <input name=file
                                    type=file
                                    id=image_uploader_input />
                             
                             <button class='submit'>Upload</button>
                           </form>
                         </p>"""
        return text.replace(/\n\(image\)\n/g, widget_html)
    }
  ]

