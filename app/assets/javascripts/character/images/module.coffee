

chr.module 'images', (module) ->
  module.on 'start', ->
    $('#character').after """<div id='chr_images' class='chr-images'>
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

    $('#chr_images_close, #chr_images_cancel').on 'click', -> chr.execute('closeImages')

chr.commands.setHandler 'showImages', -> $('#chr_images').addClass('open')
chr.commands.setHandler 'closeImages', -> $('#chr_images').removeClass('open')