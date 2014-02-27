
@Character.Plugins.images = ->
  window.showImagesOverlay()

$ ->
  $container = $('#character')

  $container.after """<div id='chr_images' class='chr-images'>
                        <div class='chr-images-dialog'>
                          <header class='chr-images-header'>
                            <span class='title'>Images</span>
                            <button id='chr_images_close' type='button' class='chr-images-close'><i class='chr-icon icon-close-alt'></i></button>
                          </header>
                          <section class='chr-images-grid'></section>
                          <footer class='chr-images-footer'>
                            <button class='chr-image-button-select'>Save</button>
                            <button id='chr_images_cancel'>Cancel</button>
                          </footer>
                        </div>
                      </div>"""

  $overlay = $('#chr_images')

  window.showImagesOverlay = ->
    $overlay.addClass 'open'
    $overlay.focus()

  window.hideImagesOverlay = ->
    $overlay.removeClass 'open'

  $('#chr_images_close, #chr_images_cancel').on 'click', window.hideImagesOverlay