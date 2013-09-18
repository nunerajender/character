class @GenericDetailsHeaderView extends Backbone.Marionette.ItemView
  template: (serialized_model) =>
    custom_template  = JST["#{ window.character_namespace }/templates/#{ @collection.options.scope }/details_header"]
    regular_template = JST["character/generic/templates/details_header"]
    (custom_template || regular_template)(serialized_model)

  modelEvents:
    'change': 'render'

  ui:
    btn_close: '#action_close'

  onRender: ->
    if @collection.options.collection_scope
      @ui.btn_close.attr 'href', "#/#{ @collection.options.scope }/#{ @collection.options.collection_scope.slug }"
    else
      @ui.btn_close.attr 'href', "#/#{ @collection.options.scope }"