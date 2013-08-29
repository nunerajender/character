class @GenericDetailsView extends Backbone.Marionette.Layout
  template: (serialized_model) =>
    custom_template  = JST["character/generic/templates/#{ window.character_namespace }/#{ @collection.options.scope }/details"]
    regular_template = JST["character/generic/templates/details"]
    (custom_template || regular_template)(serialized_model)

  regions:
    header:  '#details_header'

  ui:
    content:    '#details_content'
    footer:     '#details_footer'

  events:
    'click #action_delete': 'on_delete'
    'click #action_close':  'on_close'


  # render header as view
  onRender: ->
    header_view = new GenericDetailsHeaderView { model: @model, collection: @collection }
    @header.show(header_view)


  scope: ->
    @collection.options.scope


  # this method updates forms html and starts all related plugins
  update_content: (html) ->
    @ui.content.html(html)

    @ui.form = @ui.content.find('form')

    if @ui.form
      @ui.form.addClass('custom')

      simple_form.set_foundation_date_layout()

      @ui.content.foundation('section', 'resize')
      @ui.content.foundation('forms', 'assemble')

      @ui.submit_btn = @ui.content.find('.chr-btn-submit')

      params = {}

      # this should be extended when scopes are added

      if @collection.options.order_by
        params.fields_to_include = @collection.options.order_by.split(':')[0]

      params.title_field = @collection.options.item_title if @collection.options.item_title
      params.meta_field  = @collection.options.item_meta  if @collection.options.item_meta

      @ui.form.ajaxForm
        data: params
        beforeSubmit: (arr, $form, options) =>
          # dates fix
          _.each simple_form.get_date_values(arr), (el) -> arr.push el

          # disable button
          @ui.submit_btn.addClass 'disabled'

          return true

        success: (response) =>
          @save_model(response)

          # enable button
          @ui.submit_btn.removeClass 'disabled'

      # this allows to attach plugins when form is rendered
      # specific to all forms
      $(document).trigger "character.details.form.rendered", [ @el ]

      # this allows to attach plugins when form is rendered
      # specific to character module
      $(document).trigger "character.#{ @scope() }.details.form.rendered", [ @el ]


  save_model: (obj) ->
    # when form is submitted but returns an error
    if typeof(obj) == 'string' then return @update_content(obj)

    # update model
    obj['__scope'] = @scope()

    if @model
      @model.set(obj)
      @collection.sort()
    else
      @collection.add(obj)


  on_delete: (e) ->
    if confirm("Do you really want to remove: '#{ @model.get('__title') }'?")
      @close()
      @model.destroy()
    else
      e.preventDefault() if e


  on_close: (e) ->
    @close()

