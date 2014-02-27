# ---------------------------------------------------------
# HOTKEYS
# ---------------------------------------------------------

$ ->
  $(document).on 'keyup', (e) ->
    # ESC
    if e.keyCode == 27
      # close images dialog
      if $('#chr_images').hasClass 'open'
        window.hideImagesOverlay()

      # close error dialog
      else if $('#chr_error').hasClass 'open'
        window.hideErrorOverlay()

      # close details view
      else
        window?.closeDetailsView()