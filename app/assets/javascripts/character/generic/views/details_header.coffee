class @GenericDetailsHeaderView extends Backbone.Marionette.ItemView
  template: JST["character/generic/templates/custom/details_header"] || JST["character/generic/templates/details_header"]

  modelEvents:
    'change': 'render'

  ui:
    btn_close: '#action_close'

  onRender: ->
    @ui.btn_close.attr 'href', "#/#{ @collection.options.scope }"

