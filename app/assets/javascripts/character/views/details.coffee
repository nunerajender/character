class @CharacterAppDetailsHeaderView extends Backbone.Marionette.ItemView
  template: JST["character/templates/details_header"]
  
  modelEvents:
    'change': 'render'

  ui:
    btn_close: '#action_close'

  onRender: ->
    @ui.btn_close.attr 'href', "#/#{ @collection.scope }"



class @CharacterAppDetailsView extends Backbone.Marionette.Layout
  template: JST["character/templates/details"]

  regions:
    header:  '#details_header'

  ui:
    content:   '#details_content'
    footer:    '#details_footer'

  events:
    'click #action_delete': 'on_delete'
    'click #action_close':  'on_close'

  # render header as view
  onRender: ->
    header_view = new CharacterAppDetailsHeaderView { model: @model, collection: @collection }
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

      # This sets simple_form date input type layout combined with Foundation

      $('.row.chr-date-dmy select:eq(0)').wrap('<div class="small-3 columns chr-date-day" />')
      $('.row.chr-date-dmy select:eq(1)').wrap('<div class="small-5 columns chr-date-month" />')
      $('.row.chr-date-dmy select:eq(2)').wrap('<div class="small-4 columns chr-date-year" />')

      @ui.content.foundation('section', 'resize')
      @ui.content.foundation('forms', 'assemble')

      @ui.form.ajaxForm 
        beforeSubmit: (arr, $form, options) ->
          date_fields = simple_form.get_date_values(arr)
          _.each date_fields, (el) ->
            arr.push el
          return true
        success: (response) => @save_model(response)

      # this allows to attach plugins when form is rendered
      $(document).trigger "character.#{ @scope() }.details.form.rendered", [ @el ]

  save_model: (obj) ->
    # when form is submitted but returns an error
    if typeof(obj) == 'string' then return @update_content(obj)
    # update model
    obj['__scope'] = @scope()
    if @model
      @model.set(obj)
    else
      # TODO: need to figure out why sometimes collection does not refresh
      @collection.character_fetch()

  on_delete: (e) ->
    if confirm("Do you really want to remove: '#{ @model.get('__title') }'?")
      @close()
      console.log @model
      window.temp = @model
      @model.destroy() # TODO: this event sometimes do now work, probably cause of the server response
    else
      e.preventDefault() if e

  on_close: (e) ->
    @close()



