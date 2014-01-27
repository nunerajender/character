#= require_self
#= require ./categories

@Character.Blog ||= {}

@Character.Utils ||= {}
@Character.Utils.startPostMediumEditor = ($content) ->
  $content.title_editor = new MediumEditor '#post_title',
    disableReturn:  true
    disableToolbar: true
    placeholder:    'Post Title'

  $content.body_editor  = new MediumEditor '#post_body',
    targetBlank: true
    placeholder: 'Type your text here...'

  $('#post_body').mediumInsert
    editor: $content.body_editor
    images: true

@Character.Utils.stopPostMediumEditor = ($content)->
  $content.title_editor.deactivate()
  $('#post_body').mediumInsert('disable')
  $content.body_editor.deactivate()
  # dangerous for global plugins that use resize event, but still:
  $(window).off('resize')

$ ->
  $(document).on 'chr-posts-details-content.rendered', (e, $content) ->
    Character.Utils.startPostMediumEditor($content)

  $(document).on 'chr-posts-details-content.closed', (e, $content) ->
    Character.Utils.stopPostMediumEditor($content)