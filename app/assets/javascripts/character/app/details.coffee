@Character.App ||= {}
@Character.App.DetailsView = Backbone.Marionette.Layout.extend
  className: 'chr-app-details'
  template: -> "<header id=header class='chr-app-details-header'></header>
                <div id=form_view class='chr-app-details-form'></div>"

  regions:
    header: '#header'

  ui:
    action_save:   '#action_save'
    action_delete: '#action_delete'
    form_view:     '#form_view'

  initialize: ->
    @DetailsHeaderView = @options.app.DetailsHeaderView
    @router = @options.app.router

  onRender: ->
    header_view = new @DetailsHeaderView({ model: @model, name: "New #{ @options.name }" })
    @header.show(header_view)

    @$el.addClass('edit') if @model

    $.get @options.url, (html) => @updateContent(html)

  updateContent: (form_html) ->
    ( @ui.form_view.html(form_html) ; @onFormRendered() ) if @ui.form_view

  onFormRendered: ->
    @ui.form = @ui.form_view.find('form')
    if @ui.form.length > 0

      # include fields to properly update item in a list and sort
      params = @collection.options.constant_params
      if @collection.sortField
        params.fields_to_include = _([ params.fields_to_include, @collection.sortField ]).uniq().join(',')

      @ui.form.ajaxForm
        data: params
        beforeSubmit: (arr, $form, options) =>
          # date fixes for rails
          _(Character.Plugins.get_date_field_values(arr)).each (el) -> arr.push(el)
          @ui.action_save.addClass('disabled')
          return true
        success: (resp) => @ui.action_save.removeClass('disabled') ; @updateModel(resp)

      $(document).trigger('rendered.chrForm', [ @ui.form ])
      @afterFormRendered?()

  updateModel: (resp) ->
    # when response is a string, that means form with errors returned
    if typeof(resp) == 'string' then return @updateContent(resp)
    # assuming response is json
    if @model then @model.set(resp) else @collection.add(resp)
    @collection.sort()

  events:
    'click #action_save':   'onSave'
    'click #action_delete': 'onDelete'

  onSave: ->
    @ui.form.submit() ; return false

  onDelete: ->
    if confirm("""Are you sure about deleting "#{ @model.getTitle() }"?""")
      @close() ; @model.destroy() ; @router.navigate(chr.path)
    return false