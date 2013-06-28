class @CharacterAppDetailsHeaderView extends Backbone.Marionette.ItemView
  template: JST["character/templates/details_header"]
  modelEvents:
    'change': 'render'


class @CharacterAppDetailsView extends Backbone.Marionette.Layout
  template: JST["character/templates/details"]

  regions:
    header:  '#details_header'

  ui:
    content: '#details_content'
    footer:  '#details_footer'

  events:
    'click #action_delete': 'on_delete'
    'click #action_close':  'on_close'

  # render header as view
  onRender: ->
    header_view = new CharacterAppDetailsHeaderView { model: @model }
    @header.show(header_view)

  scope: ->
    @collection.scope

  # this method updates forms html and
  # then start all related plugins
  update_content: (html) ->
    @ui.content.html(html)

    @ui.form = @ui.content.find('form')
    
    if @ui.form
      @ui.form.addClass('custom')
      @ui.content.foundation('section', 'resize')
      @ui.content.foundation('forms', 'assemble')

      @ui.form.ajaxForm { success: (response) => @save_model(response) }

      # this allows to attach plugins when form is rendered
      $(document).trigger "character.#{ @scope() }.details.form.rendered", [ @el ]

  save_model: (obj) ->
    # when form is submitted but returns an error
    if typeof(obj) == 'string' then return @update_content(obj)
    # update model
    obj['__scope'] = @scope()
    if @model then @model.set(obj) else @collection.add(obj)

  on_delete: (e) ->
    if confirm("Do you really want to remove: '#{ @model.get('__title') }'?")
      @close()
      @model.destroy() # TODO: this event sometimes do now work, probably cause of the server response
    else
      e.preventDefault() if e

  on_close: (e) ->
    @close()



